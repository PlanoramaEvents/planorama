class Survey::SubmissionsController < ResourceController
  SERIALIZER_CLASS = 'Survey::SubmissionSerializer'.freeze
  MODEL_CLASS = 'Survey::Submission'.freeze
  POLICY_CLASS = 'Survey::SubmissionPolicy'.freeze
  POLICY_SCOPE_CLASS = 'Survey::SubmissionPolicy::Scope'.freeze
  XLS_SERIALIZER_CLASS = 'Survey::SubmissionXlsSerializer'.freeze
  DEFAULT_SORTBY = 'survey_submissions.updated_at'

  def can_access_question?(question, person)
    if question.private
      AccessControlService.allowed_sensitive_access?(person: person)
    elsif question.linked_field
      AccessControlService.linked_field_access?(linked_field: question.linked_field, person: person)
    else
      true
    end
  end

  def can_access_response?(response, person)
    # if it is my response then I can have access
    return true if response.submission&.person_id == person.id

    if response.question.private
      AccessControlService.allowed_sensitive_access?(person: person)
    elsif response.question.linked_field
      AccessControlService.linked_field_access?(linked_field: response.question.linked_field, person: person)
    else
      true
    end
  end

  def belong_to_class
    return Survey if params[:survey_id].present?
    return Person if params[:person_id].present?
  end

  def belongs_to_relationship
    'submissions'
  end

  def belongs_to_param_id
    params[:survey_id] || params[:person_id]
  end

  def before_save
    # Make sure the submission is assigned to the current person
    # if there is one ... and survey is not unassigned
    @object.person_id = current_person.id if current_person
  end

  # After save and if state changes to submitted we may need
  # to transistion the person's state?
  def after_save
    process_responses
    post_submission_transition if @object.submission_state == Survey::Submission.submission_states[:submitted]
  end

  def after_update
    process_responses
    post_submission_transition if @object.submission_state == Survey::Submission.submission_states[:submitted]
  end

  def process_responses
    p = params.require(:data).permit! #({attributes: {responses_attributes: [:id, :lock_version, :submission_id, :question_id, :response]}})
    responses = p[:attributes][:responses_attributes]

    if (responses)
      # Rails.logger.debug("****** SAVE RESPONSES #{responses}")
      responses.each do |res|
        # Rails.logger.debug("****** SAVE RESPONSE #{res}")
        r = Survey::Response.exists? res[:id]
        if r
          r.update(res)
        else
          Survey::Response.create(
            res
          )
        end
      end
    end
  end

  def post_submission_transition
    acceptance_status = @object.survey.transition_accept_status
    return unless acceptance_status
    return unless @object.person_id || (@object.person_id != current_person.id)

    current_person.con_state = acceptance_status
    current_person.save!
  end

  def index
    format = params[:format]

    # If XLS then we do somethng else
    if (format == 'xls') || (format == 'xlsx')
      send_data collection_to_xls,
        filename: "submissions_#{Time.now.strftime('%m-%d-%Y')}.xlsx",
        disposition: 'attachment'
    else
      super
    end
  end

  # 
  # Use a report config to get the submissions from a survey
  # based on a query AND only a subset of the questions
  # 
   def filtered_submissions
    authorize model_class, policy_class: policy_class

    # Get the report config
    report_config_id = params[:report_config_id]
    report_config = Survey::ReportConfig.find report_config_id

    raise "No custom submission report" unless report_config

    workbook = FastExcel.open(constant_memory: true) # creates tmp file
    worksheet = workbook.add_worksheet("Export")
    
    #  Get Styles for the sheets
    wrap_style = workbook.add_format()
    wrap_style.set_text_wrap()
    date_time_style = workbook.number_format("d mmm yyyy h:mm")
    styles = [date_time_style,date_time_style, nil, nil]
    # Get submissions
    submisisons = ReportsService.survey_report(report_config: report_config)
    # Convert to XLS
    survey = report_config.survey
    # updated_at, email (from person), status (from person), name (from person)
    header = ['Updated At', 'Email', 'Status', 'Name'] # TODO: need person parameters
    posn = 4
    response_columns = {}
    # NOTE: this query makes sure that the order of the questions is maintained
    question_ids = report_config.question_ids
    question_labels = report_config.question_labels
    questions = Survey::Question.find_by_sql([
      "select * from survey_questions where survey_questions.id in (?) order by array_position(ARRAY[?], TEXT(survey_questions.id))",
      question_ids, question_ids
    ])
    questions.each do |question|
      next if [:hr, :textonly].include? question.question_type
      styles << wrap_style

      if question_labels
        header << question_labels[question.id]
      else
        header << question.clean_question.strip
      end
      response_columns[question.id] = posn
      posn += 1
    end
    worksheet.set_columns_width(0, posn -1, width = 50)
    worksheet.append_row(header)

    submisisons.each do |submission|
      row = [submission.person.updated_at, submission.person.email, submission.person.con_state, submission.person.name]
      row.concat Array.new(response_columns.size)
      submission.responses.each do |response|
        if response_columns[response.question_id]
          if can_access_response?(response, current_person)
            row[response_columns[response.question_id]] = response.response_clean_text #.strip
          else
            row[response_columns[response.question_id]] = "Restricted"
          end
        end
      end
      worksheet.append_row(
        row,
        styles
      )
    end

    # Use name from config in the filename
    send_data workbook.read_string,
        filename: "#{report_config.name.gsub(/\s/,'_')}_#{Time.now.strftime('%m-%d-%Y')}.xlsx",
        disposition: 'attachment'
  end

  # faster collection to Excel
  def collection_to_xls
    workbook = FastExcel.open(constant_memory: true) # creates tmp file
    worksheet = workbook.add_worksheet("Export")

    #  Get Styles for the sheets
    wrap_style = workbook.add_format()
    wrap_style.set_text_wrap()
    date_time_style = workbook.number_format("d mmm yyyy h:mm")
    styles = [date_time_style,date_time_style, nil]
    # Get the survey questions
    submission = @collection.first

    survey = Survey.find params[:survey_id] if params[:survey_id]
    survey ||= submission.survey
    header = ['Created At', 'Updated At', 'Email']
    response_columns = {}
    posn = 3
    survey.questions.sorted.each do |question|
      next if [:hr, :textonly].include? question.question_type
      styles << wrap_style
      
      header << question.clean_question.strip

      response_columns[question.id] = posn
      posn += 1
    end
    worksheet.set_columns_width(0, posn -1, width = 50)
    worksheet.append_row(header)

    @collection.each do |submission|
      row = [submission.created_at, submission.updated_at, submission.person.email]
      row.concat Array.new(response_columns.size)
      submission.responses.each do |response|
        if response_columns[response.question_id]
          if can_access_response?(response, current_person)
            row[response_columns[response.question_id]] = response.response_clean_text.strip
          else
            row[response_columns[response.question_id]] = "Restricted"
          end
        end
      end
      worksheet.append_row(
        row,
        styles
      )
    end
    workbook.read_string
  end

  def flat
    authorize model_class, policy_class: policy_class
    load_resource

    meta = {}
    meta[:total] = @collection_total if paginate
    meta[:full_total] = @full_collection_total ? @full_collection_total : @collection_total if paginated
    meta[:current_page] = @current_page if @current_page.present? && paginate
    meta[:perPage] = @per_page if @per_page.present? && paginate

    # This is only loading responses that matc, shoudl be all response in the submission
    options = {
      meta: meta,
      params: {
        domain: "#{request.base_url}",
        current_person: current_person
      }
    }
    options[:fields] = fields

    render json: Survey::SubmissionFlatSerializer.new(@collection,options).serializable_hash(),
           content_type: 'application/json'
  end

  # TODO: remove name column from survey submission

  def collection_actions
    [:index, :flat]
  end

  def serializer_includes
    [
      :responses
    ]
  end

  def includes
    [
      :person
    ]
  end

  def references
    [
      :person
    ]
  end

  def join_tables
    [
      :responses
    ]
  end

  def delete_all
    Survey.transaction do
      survey = Survey.find_by(id: params[:survey_id])
      authorize survey, policy_class: policy_class

      survey.submissions.destroy_all

      render status: :ok, json: {}.to_json, content_type: 'application/json'
    end
  end

  # Corrected structure for nested attrs
  # BUT - client is sending a new response with a UUID which is confusing Rails
  # because a new instance is not expected to have a id...
  def allowed_params
    %i[
      id
      lock_version
      person_id
      survey_id
      responses
      person
      survey
      submission_state
    ]
    # responses_attributes
    # ] << [
    #   responses_attributes: %i[
    #     id
    #     lock_version
    #     _destroy
    #     submission_id
    #     question_id
    #     response
    #   ]
    # The response should be plain JSON
  end
end

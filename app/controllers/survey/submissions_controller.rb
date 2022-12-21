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
    # if there is one ... and survey is not anonymous
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

  # faster collection to Excel
  def collection_to_xls
    workbook = FastExcel.open(constant_memory: true) # creates tmp file
    worksheet = workbook.add_worksheet("Export")
    date_time_style = workbook.number_format("d mmm yyyy h:mm")
    styles = [date_time_style,date_time_style]
    # Get the survey questions
    submission = @collection.first

    survey = Survey.find params[:survey_id] if params[:survey_id]
    survey ||= submission.survey
    header = ['Created At', 'Updated At', 'Email']
    response_columns = {}
    posn = 3
    survey.questions.each do |question|
      next if [:hr, :textonly].include? question.question_type
      next unless can_access_question?(question, current_person)

      header << question.question

      response_columns[question.id] = posn
      posn += 1
    end
    worksheet.append_row(header)

    @collection.each do |submission|
      row = [submission.created_at, submission.updated_at, submission.person.email]
      row.concat Array.new(response_columns.size)
      submission.responses.each do |response|
        if response_columns[response.question_id] && can_access_response?(response, current_person)
          row[response_columns[response.question_id]] = response.response_as_text
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

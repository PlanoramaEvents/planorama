class SurveysController < ResourceController
  SERIALIZER_CLASS = 'SurveySerializer'.freeze
  POLICY_CLASS = 'SurveyPolicy'.freeze
  POLICY_SCOPE_CLASS = 'SurveyPolicy::Scope'.freeze
  DEFAULT_SORTBY = 'surveys.updated_at'.freeze
  DEFAULT_ORDER = 'desc'.freeze

  def assign_people
    authorize current_person, policy_class: policy_class
    people_ids = params.permit(people: [:id])

    Survey.transaction do
      survey = Survey.find params[:survey_id]
      people = Person.find people_ids.to_h[:people].collect{|a| a[:id] }

      survey.assigned_people << people

      render_object(survey, includes: false)
    end
  end

  def unassign_people
    authorize current_person, policy_class: policy_class
    people_ids = params.permit(people: [:id])

    Survey.transaction do
      survey = Survey.find params[:survey_id]
      people = Person.find people_ids.to_h[:people].collect{|a| a[:id] }

      survey.assigned_people.delete people

      render_object(survey, includes: false)
    end
  end

  # TODO: add filter to survey index for assigned people, TEST

  def serializer_includes
    [
      :pages,
      :'pages.questions',
      :'pages.questions.answers',
      # :submissions
      :created_by,
      :updated_by,
      :published_by
    ]
  end

  def includes
    [
      {
        pages: {
          questions: :answers
        }
      },
      # :submissions,
      :created_by,
      :updated_by,
      :published_by
      # :assigned_people
    ]
  end

  def references
    [
      # :assigned_people,
      :submissions
    ]
  end

  def join_tables
    surveys = Arel::Table.new(Survey.table_name)
    updated_by = Arel::Table.new(Person.table_name).alias('updated_by')
    [
      surveys.create_join(
        updated_by,
        surveys.create_on(
          surveys[:updated_by_id].eq(updated_by[:id])
        ),
        Arel::Nodes::OuterJoin
      )
    ]
  end

  def before_save
    @object.created_by_id = current_person.id
    @object.updated_by_id = current_person.id
    check_for_publish
  end

  def before_update
    @object.updated_by_id = current_person.id
    check_for_publish
  end

  def check_for_publish
    # check if going to be published
    # If we are going to publish then public is set to true
    return unless permitted_params['public']
    # If it was not already published the old value would be false
    return if @object.public

    @object.published_by_id = current_person.id
    @object.published_on = Time.now
  end

  def allowed_params
    %i[
      id
      lock_version
      name
      thank_you
      submit_string
      use_captcha
      public
      transition_accept_status
      transition_decline_status
      declined_msg
      authenticate_msg
      unassigned
      welcome
      description
      mandatory_star
      numbered_questions
      branded
      allow_submission_edits
      pages
      pages_attributes
      unique_submission
    ]
    # << [
    #   pages_attributes: %i[
    #     id
    #     title
    #     next_page_id
    #     next_page_action
    #     sort_order
    #     survey_id
    #     lock_version
    #     _destroy
    #     questions
    #   ] << [
    #     questions_attributes: %i[
    #       id
    #       title
    #       question
    #       question_type
    #       lock_version
    #       mandatory
    #       text_size
    #       sort_order
    #       horizontal
    #       private
    #       regex
    #       branching
    #       _destroy
    #       answers
    #     ] << [
    #       answers_attributes: %i[
    #         id
    #         answer
    #         lock_version
    #         default
    #         sort_order
    #         _destroy
    #         other
    #         next_page_id
    #         next_page_action
    #       ]
    #     ]
    #   ]
    # ]
  end
end

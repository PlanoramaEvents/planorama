class SurveysController < ResourceController
  SERIALIZER_CLASS = 'SurveySerializer'.freeze
  POLICY_CLASS = 'SurveysPolicy'.freeze
  DEFAULT_ORDER = 'updated_at'

  def serializer_includes
    [
      :survey_pages,
      :'survey_pages.survey_questions',
      :'survey_pages.survey_questions.survey_answers'
      # :created_by,
      # :updated_by,
      # :published_by
    ]
  end

  def includes
    [
      {
        survey_pages: {
          survey_questions: :survey_answers
        }
      },
      :created_by,
      :updated_by,
      :published_by
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
    return unless permitted_params[:public]
    # If it was not already published the old value would be false
    return if @object.public

    @object.published_by_id = current_person.id
    @object.published_on = Time.now
  end

  def allowed_params
    %i[
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
      anonymous
      welcome
      description
      mandatory_star
      numbered_questions
      branded
      allow_submission_edits
    ] << [
      survey_pages_attributes: %i[
        id
        title
        next_page_id
        sort_order
        survey_id
        lock_version
        _destroy
      ] << [
        survey_questions_attributes: %i[
          id
          title
          question
          question_type
          lock_version
          mandatory
          text_size
          sort_order
          horizontal
          private
          regex
          branching
          _destroy
        ] << [
          survey_answers_attributes: %i[
            id
            answer
            lock_version
            default
            sort_order
            _destroy
            other
            next_page_id
          ]
        ]
      ]
    ]
  end
end

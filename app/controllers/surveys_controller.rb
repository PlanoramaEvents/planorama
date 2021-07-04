class SurveysController < ResourceController
  SERIALIZER_CLASS = 'SurveySerializer'.freeze
  POLICY_CLASS = 'SurveysPolicy'.freeze

  def serializer_includes
    [
      {
        survey_pages: {
          survey_questions: :survey_answers
        },
      },
      :created_by,
      :updated_by,
      :published_by
    ]
  end

  def includes
    serializer_includes
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
      alias
      submit_string
      header_image
      use_captcha
      public
      authenticate
      transition_accept_status
      transition_decline_status
      declined_msg
      authenticate_msg
      anonymous
      welcome
      description
      fuuid
    ] << [
      survey_pages_attributes: %i[
        id
        title
        next_page_id
        sort_order
        survey_id
        lock_version
        fuuid
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
          fuuid
          _destroy
        ] << [
          survey_answers_attributes: %i[
            id
            answer
            lock_version
            default
            sort_order
            fuuid
            _destroy
          ]
        ]
      ]
    ]
  end
end

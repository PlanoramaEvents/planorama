class SurveysController < ResourceController
  SERIALIZER_CLASS = 'SurveySerializer'.freeze

  def serializer_includes
    [
      {
        survey_pages: {
          survey_questions: :survey_answers
        }
      }
    ]
  end

  def includes
    [
      :created_by,
      :updated_by,
      :published_by,
    ] << serializer_includes
  end

  def before_save
    @object.created_by_id = current_person.id
  end

  def before_update
    @object.updated_by_id = current_person.id
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
      published_on
      published_by
      description
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
          _destroy
        ] << [
          survey_answers_attributes: %i[
            id
            answer
            lock_version
            default
            sort_order
            _destroy
          ]
        ]
      ]
    ]
  end
end

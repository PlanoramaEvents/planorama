class SurveysController < ResourceController
  SERIALIZER_CLASS = 'SurveySerializer'.freeze

  def includes
    [{
      survey_pages: {
        survey_questions: :survey_answers
      }
    }]
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

class SurveysController < ResourceController
  # SERIALIZER_CLASS = 'SurveySerializer'.freeze

  # def includes
  #   [
  #     {
  #       survey_questions: :survey_answers
  #     }
  #   ]
  # end

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
    ]
  end
end

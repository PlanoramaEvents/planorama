class SurveySerializer < ActiveModel::Serializer
  attributes :id, :created_at, :updated_at, :lock_version,
    :name, :welcome, :thank_you, :alias, :submit_string,
    :header_image, :use_captcha, :public, :authenticate,
    :transition_accept_status, :transition_decline_status,
    :declined_msg, :authenticate_msg, :anonymous

  has_many :survey_pages
  has_many :survey_questions, serializer: Survey::QuestionSerializer
end

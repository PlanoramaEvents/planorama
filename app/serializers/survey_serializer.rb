class SurveySerializer < ActiveModel::Serializer
  attributes :id, :created_at, :updated_at, :lock_version,
    :name, :welcome, :thank_you, :alias, :submit_string,
    :header_image, :use_captcha, :public, :authenticate,
    :transition_accept_status, :transition_decline_status,
    :declined_msg, :authenticate_msg, :anonymous,
    :published_on, :published_by_id,
    :created_by_id, :updated_by_id, :description

  has_many :survey_pages, serializer: Survey::PageSerializer
end

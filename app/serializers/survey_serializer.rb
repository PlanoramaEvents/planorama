class SurveySerializer
  include JSONAPI::Serializer

  attributes :id, :created_at, :updated_at, :lock_version,
             :name, :welcome, :thank_you, :submit_string,
             :use_captcha, :public,
             :transition_accept_status, :transition_decline_status,
             :declined_msg, :authenticate_msg, :anonymous,
             :published_on, :description, :fuuid,
             :mandatory_star,
             :numbered_questions,
             :branded,
             :allow_submission_edits

  has_many :survey_pages, serializer: Survey::PageSerializer
  #
  belongs_to :published_by, serializer: PersonSerializer
  belongs_to :created_by, serializer: PersonSerializer
  belongs_to :updated_by, serializer: PersonSerializer

  attribute :nbr_submissions do |object|
    object.survey_submissions.size
  end
end

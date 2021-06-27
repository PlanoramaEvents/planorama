class Survey::SubmissionSerializer < ActiveModel::Serializer
  attributes :id, :lock_version, :survey_id, :person_id

  has_many :survey_responses, serializer: Survey::ResponseSerializer
end

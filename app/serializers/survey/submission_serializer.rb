class Survey::SubmissionSerializer < ActiveModel::Serializer
  attributes :id, :lock_version, :survey_id, :person_id, :fuuid

  # has_many :survey_responses, serializer: Survey::ResponseSerializer
  # has_many :survey_responses do
  #   object.survey_responses.collect{|r| {r.survey_question.question => r.response_as_text}}
  # end

end

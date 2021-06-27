class Survey::ResponseSerializer < ActiveModel::Serializer
  attributes :id, :lock_version, :survey_submission_id,
             :survey_question_id,
             :response
  # TODO: test that response comes back ok as JSON
end

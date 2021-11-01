class Survey::ResponseSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :submission_id,
             :question_id,
             :response, :fuuid
  # TODO: test that response comes back ok as JSON
end

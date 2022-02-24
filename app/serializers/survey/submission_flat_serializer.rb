class Survey::SubmissionFlatSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :survey_id, :person_id, :submission_state,
             :created_at, :updated_at


  attribute :submitter do |object|
    object.person.name if object.person
  end

  attribute :xx do |object|
    "xx"
  end

  # Provide a flat view of responses question id => value
  attribute :responses do |object|
    # object.responses.collect{|r| {r.question.id => r.response_as_text}}
    res = {}
    object.responses.each do |r|
      res[r.question.id] = r.response_as_text
    end
    res
  end
end

class Survey::SubmissionFlatSerializer
  include JSONAPI::Serializer
  include Plano::AccessHelper

  attributes :id, :lock_version, :survey_id, :person_id, :submission_state,
             :created_at, :updated_at


  attribute :submitter do |object|
    object.person.name if object.person
  end

  # Provide a flat view of responses question id => value
  attribute :responses do |object, params|
    res = {}
    object.responses.each do |r|
      res[r.question.id] = r.response_as_text if self.can_access_response?(r,params[:current_person])
    end
    res
  end
end

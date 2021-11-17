class Survey::SubmissionSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :survey_id, :person_id, :submission_state,
             :created_at, :updated_at


  attribute :submitter do |object|
    object.person.name if object.person
  end

  has_many :responses,
            links: {
              self: -> (object, params) {
                "#{params[:domain]}/submission/#{object.id}"
              },
              related: -> (object, params) {
                "#{params[:domain]}/submission/#{object.id}/responses"
              }
            } do |object|
              object.responses.collect{|r| {r.survey_question.question => r.response_as_text}}
            end
end

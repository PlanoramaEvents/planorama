class Survey::ResponseSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :submission_id,
             :question_id,
             :response
  # TODO: test that response comes back ok as JSON

  # belongs_to :submission #, serializer: PersonSerializer
  belongs_to :submission,
    links: {
      self: -> (object, params) {
        "#{params[:domain]}/response/#{object.id}"
      },
      related: -> (object, params) {
        "#{params[:domain]}/submission/#{object.submission_id}"
      }
    }

end

class Survey::ResponseSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :submission_id,
             :question_id,
             :response

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

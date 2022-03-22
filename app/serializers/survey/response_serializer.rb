class Survey::ResponseSerializer
  include JSONAPI::Serializer
  include Plano::AccessHelper

  attributes :id, :lock_version, :submission_id,
             :question_id

  attribute :response, if: Proc.new { |record, params| self.can_access_response?(record,params[:current_person]) }


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

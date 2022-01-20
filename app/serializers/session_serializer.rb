class SessionSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :created_at, :updated_at, :title, :description

  has_one :format,
          if: Proc.new { |record| record.format },
          links: {
            self: -> (object, params) {
              "#{params[:domain]}/session/#{object.id}"
            },
            related: -> (object, params) {
              "#{params[:domain]}/format/#{object.format.id}"
            }
          }

end

class SessionLimitSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :created_at, :updated_at,
             :person_id, :day, :max_sessions

  belongs_to :person,
            if: Proc.new { |record| record.person_id },
            links: {
              self: -> (object, params) {
                "#{params[:domain]}/session_limit/#{object.id}"
              },
              related: -> (object, params) {
                "#{params[:domain]}/person/#{object.person_id}"
              }
            }
end

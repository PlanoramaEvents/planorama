class RegistrationSyncDatumSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :created_at, :updated_at,
             :reg_id, :registration_number, :name, :email,
             :preferred_name, :alternative_email,
             :raw_info

  # The people that this data could be macthed to
  has_many :people, serializer: PersonSerializer,
              links: {
                self: -> (object, params) {
                  "#{params[:domain]}/registration_sync_datum/#{object.id}"
                },
                related: -> (object, params) {
                  "#{params[:domain]}/registration_sync_datum/#{object.id}/people"
                }
              }
end

#
class PersonSyncDatumSerializer
  include JSONAPI::Serializer

  attributes :id, :name, :name_sort_by, :name_sort_by_confirmed,
             :pseudonym, :pseudonym_sort_by, :pseudonym_sort_by_confirmed,
             :published_name, :published_name_sort_by,
             :job_title, :organization, :reg_id,
             :primary_email, :contact_email


  has_many  :email_addresses, 
              if: Proc.new { |record, params| AccessControlService.shared_attribute_access?(instance: record, person: params[:current_person]) },
              lazy_load_data: true, serializer: EmailAddressSerializer,
              links: {
                self: -> (object, params) {
                  "#{params[:domain]}/person/#{object.id}"
                },
                related: -> (object, params) {
                  "#{params[:domain]}/person/#{object.id}/email_addresses"
                }
              }
  
  # The reg data that this person could be matched to
  has_many :registration_sync_data, serializer: RegistrationSyncDatumSerializer
              # links: {
              #   self: -> (object, params) {
              #     "#{params[:domain]}/person_sync_data/#{object.id}"
              #   },
              #   related: -> (object, params) {
              #     "#{params[:domain]}/registration_sync_datum/#{object.id}/registration_sync_data"
              #   }
              # }
end

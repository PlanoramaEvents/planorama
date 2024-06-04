# == Schema Information
#
# Table name: registration_sync_data
#
#  id                  :uuid             not null, primary key
#  alternative_email   :string
#  email               :string
#  lock_version        :integer
#  name                :string
#  preferred_name      :string
#  raw_info            :jsonb            not null
#  registration_number :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  reg_id              :string
#
# Indexes
#
#  index_registration_sync_data_on_email                (email) USING gin
#  index_registration_sync_data_on_name                 (name) USING gin
#  index_registration_sync_data_on_reg_id               (reg_id)
#  index_registration_sync_data_on_registration_number  (registration_number)
#
class RegistrationSyncDatumSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :created_at, :updated_at,
             :reg_id, :registration_number, :name, :email,
             :preferred_name, :alternative_email,
             :raw_info

  # The people that this data could be matched to
  # has_many :people, serializer: PersonSerializer,
  #             links: {
  #               self: -> (object, params) {
  #                 "#{params[:domain]}/registration_sync_datum/#{object.id}"
  #               },
  #               related: -> (object, params) {
  #                 "#{params[:domain]}/registration_sync_datum/#{object.id}/people"
  #               }
  #             }
end

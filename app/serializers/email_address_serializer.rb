# == Schema Information
#
# Table name: email_addresses
#
#  id           :uuid             not null, primary key
#  email        :string           default("")
#  is_valid     :boolean          default(TRUE), not null
#  iscontact    :boolean          default(FALSE)
#  isdefault    :boolean          default(FALSE), not null
#  label        :string
#  lock_version :integer          default(0)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  person_id    :uuid
#
# Indexes
#
#  index_email_addresses_on_email  (email) USING gin
#
class EmailAddressSerializer
  include JSONAPI::Serializer

  attributes :email, :id, :isdefault, :lock_version

  belongs_to :person,
    if: Proc.new { |record| record.person_id },
    links: {
      self: -> (object, params) {
        "#{params[:domain]}/email_address/#{object.id}"
      },
      related: -> (object, params) {
        "#{params[:domain]}/person/#{object.person_id}"
      }
    }
end

# == Schema Information
#
# Table name: convention_roles
#
#  id           :uuid             not null, primary key
#  lock_version :integer
#  role         :enum
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  person_id    :uuid
#
# Indexes
#
#  index_convention_roles_on_person_id  (person_id)
#
class ConventionRoleSerializer
  include JSONAPI::Serializer

  attributes :role, :id

  belongs_to :person,
    links: {
      self: -> (object, params) {
        "#{params[:domain]}/convention_role/#{object.id}"
      },
      related: -> (object, params) {
        "#{params[:domain]}/person/#{object.person_id}"
      }
    }
end

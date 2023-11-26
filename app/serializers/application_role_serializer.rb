# == Schema Information
#
# Table name: application_roles
#
#  id               :uuid             not null, primary key
#  con_roles        :text             default([]), is an Array
#  lock_version     :integer          default(0)
#  name             :string           not null
#  sensitive_access :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_application_roles_on_con_roles  (con_roles) USING gin
#
class ApplicationRoleSerializer
  include JSONAPI::Serializer

  attributes :id, :created_at, :updated_at, :lock_version,
             :name, :sensitive_access

  attribute :permissions
end

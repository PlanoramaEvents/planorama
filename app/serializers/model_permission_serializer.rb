# == Schema Information
#
# Table name: model_permissions
#
#  actions             :jsonb
#  lock_version        :integer
#  mdl_name            :string           not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  application_role_id :uuid             not null, primary key
#
# Indexes
#
#  index_model_permissions_on_application_role_id  (application_role_id)
#
class ModelPermissionSerializer
  include JSONAPI::Serializer

  attributes :lock_version, :created_at, :updated_at,
             :mdl_name, :actions, :application_role_id
end

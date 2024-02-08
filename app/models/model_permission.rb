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
class ModelPermission < ApplicationRecord
  self.primary_keys = :mdl_name, :application_role_id

  belongs_to :application_role
end

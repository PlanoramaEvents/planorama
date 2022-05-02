class ModelPermission < ApplicationRecord
  self.primary_keys = :mdl_name, :application_role_id

  belongs_to :application_role
end

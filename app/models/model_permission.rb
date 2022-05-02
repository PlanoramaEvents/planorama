class ModelPermission < ApplicationRecord
  self.primary_keys = :model_name, :application_role_id

  belongs_to :application_role
end

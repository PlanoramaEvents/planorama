#
class ApplicationRole < ApplicationRecord
  has_many :model_permissions, dependent: :destroy
  accepts_nested_attributes_for :model_permissions

  has_and_belongs_to_many :people, class_name: 'Person'

  validates :name, presence: true

  # TODO: validate con_role

  def permissions
    # Get model_permissions and merge with PolicyService.list_policies
    # 1. model permissions to merged hash
    # 2. merge in the defaults to fill what is missing
    perms = PolicyService.list_policies

    model_permissions.each do |p|
      if perms[p.mdl_name]
        perms[p.mdl_name] = perms[p.mdl_name].merge p.actions
      else
        perms[p.mdl_name] = p.actions
      end
    end

    perms
  end

  def update_permissions(new_permissions)
    perms = []
    new_permissions.each do |k, v|
      entry = {
        mdl_name: k,
        actions: v,
        application_role_id: self.id
      }
      cpk = CompositePrimaryKeys::CompositeKeys[k, self.id]
      entry[:id] = cpk if ModelPermission.exists? cpk

      perms << entry
    end

    self.update(
      model_permissions_attributes: perms
    )
  end
end

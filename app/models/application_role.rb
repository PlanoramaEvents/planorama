#
class ApplicationRole < ApplicationRecord
  # has_many :model_permissions, :foreign_key => "application_role_id", dependent: :destroy
  has_many :model_permissions, dependent: :destroy
  accepts_nested_attributes_for :model_permissions

  has_and_belongs_to_many :people, class_name: 'Person'
  has_and_belongs_to_many :convention_roles, class_name: 'ConventionRole'

  validates :name, presence: true

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

  def create_permissions(new_permissions)
    perms = []
    new_permissions.each do |k, v|
      perms << {
        mdl_name: k,
        actions: v,
        application_role_id: self.id
      }
    end

    self.update(
      model_permissions_attributes: perms
    )
  end

  def update_permissions(new_permissions)
    perms = []
    new_permissions.each do |k, v|
      cpk = CompositePrimaryKeys::CompositeKeys[k, self.id]
      if ModelPermission.exists? cpk
        perms << {
          id: cpk,
          mdl_name: k,
          actions: v,
          application_role_id: self.id
        }
      else
        perms << {
          mdl_name: k,
          actions: v,
          application_role_id: self.id
        }
      end
    end

    self.update(
      model_permissions_attributes: perms
    )
  end

  # def permissions=(new_permissions)
  #   perms = []
  #   new_permissions.each do |k, v|
  #     if self.new_record?
  #       Rails.logger.debug("*************** NEW")
  #       perms << {
  #         mdl_name: k,
  #         actions: v,
  #         application_role_id: self.id
  #       }
  #     else
  #       Rails.logger.debug("*************** #{self.id}")
  #       # cpk = CompositePrimaryKeys::CompositeKeys[k, self.id]
  #       # perms << {
  #       #   id: cpk,
  #       #   mdl_name: k,
  #       #   actions: v,
  #       #   application_role_id: self.id
  #       # }
  #     end
  #   end
  #
  #   self.update(
  #     model_permissions_attributes: perms
  #   )
  # end
end

#
class ApplicationRole < ApplicationRecord
  has_many :model_permissions
  accepts_nested_attributes_for :model_permissions, allow_destroy: true

  has_many :application_role_assocs
  has_many :people, through: :application_role_assocs

  validates :name, presence: true
end


# use JSONB
# {
#   model1: {
#     action1: true,
#     action2: false
#   },
#   model1: {
#     action1: true,
#     action2: false
#   }
# }


# create_table :events do |t|
#   t.jsonb 'payload'
# end

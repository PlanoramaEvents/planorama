class ConventionRole < ApplicationRecord
  belongs_to :person

  has_and_belongs_to_many :application_roles, class_name: 'ApplicationRole'

  enum role: { admin: 'admin', staff: 'staff', participant: 'participant' }
end

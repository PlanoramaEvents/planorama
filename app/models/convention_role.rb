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
class ConventionRole < ApplicationRecord
  belongs_to :person

  enum role: { admin: 'admin', staff: 'staff', participant: 'participant' }

  def application_roles
    ApplicationRole.where("con_roles @> ?", "{#{role}}")
  end
end

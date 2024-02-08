# == Schema Information
#
# Table name: age_restrictions
#
#  id           :uuid             not null, primary key
#  lock_version :integer
#  name         :string(500)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class AgeRestriction < ApplicationRecord
  validates :name, presence: true

  has_one :session
end

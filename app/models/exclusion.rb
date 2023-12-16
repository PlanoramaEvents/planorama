# == Schema Information
#
# Table name: exclusions
#
#  id           :uuid             not null, primary key
#  lock_version :integer
#  title        :string(800)      not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Exclusion < ApplicationRecord
  # title - text 500 chars
  validates :title, presence: true

  has_many :person_exclusions, dependent: :destroy

  has_and_belongs_to_many :sessions
end

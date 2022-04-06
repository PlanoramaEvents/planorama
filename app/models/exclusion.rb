class Exclusion < ApplicationRecord
  # title - text 500 chars
  validates :title, presence: true

  has_many :person_exclusions, dependent: :destroy
end

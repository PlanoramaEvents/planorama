class SessionLimit < ApplicationRecord
  belongs_to  :person

  validates :person_id, presence: true

  # can only have one with the day null for a given person
end

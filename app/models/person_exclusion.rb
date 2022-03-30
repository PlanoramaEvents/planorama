class PersonExclusion < ApplicationRecord
  belongs_to  :person
  belongs_to  :exclusion

  validates :person_id, presence: true
  validates :exclusion_id, presence: true
end

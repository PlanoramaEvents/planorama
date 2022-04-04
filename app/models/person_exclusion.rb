class PersonExclusion < ApplicationRecord
  belongs_to  :person
  belongs_to  :exclusion

  validates :person_id, presence: true
  validates :exclusion_id, presence: true

  has_paper_trail versions: { class_name: 'Audit::PersonVersion' }, ignore: [:updated_at, :created_at]
end

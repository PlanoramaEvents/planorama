# == Schema Information
#
# Table name: person_exclusions
#
#  id           :uuid             not null, primary key
#  lock_version :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  exclusion_id :uuid
#  person_id    :uuid
#
# Indexes
#
#  index_person_exclusions_on_person_id                   (person_id)
#  index_person_exclusions_on_person_id_and_exclusion_id  (person_id,exclusion_id) UNIQUE
#
class PersonExclusion < ApplicationRecord
  belongs_to  :person
  belongs_to  :exclusion

  validates :person_id, presence: true
  validates :exclusion_id, presence: true

  has_paper_trail versions: { class_name: 'Audit::PersonVersion' }, ignore: [:updated_at, :created_at, :lock_version]
end

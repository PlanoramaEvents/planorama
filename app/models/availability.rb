class Availability < ApplicationRecord
  belongs_to :person
  validates :person_id, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  has_paper_trail versions: { class_name: 'Audit::PersonVersion' }, ignore: [:updated_at, :created_at, :lock_version]
end

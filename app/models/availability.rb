class Availability < ApplicationRecord
  belongs_to :person
  validates :person_id, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
end

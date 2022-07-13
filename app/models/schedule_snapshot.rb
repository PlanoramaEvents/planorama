class ScheduleSnapshot < ApplicationRecord
  validates_presence_of :label

  has_many :person_schedule_snapshots, dependent: :destroy

  enum status: {
    not_set: 'not_set',
    in_progress: 'in_progress',
    done: 'done',
    failed: 'failed'
  }
end

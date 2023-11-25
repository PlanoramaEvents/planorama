# == Schema Information
#
# Table name: schedule_snapshots
#
#  id           :uuid             not null, primary key
#  completed_at :datetime
#  created_by   :string
#  label        :string
#  lock_version :integer
#  started_at   :datetime
#  status       :enum             default("not_set")
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_schedule_snapshots_on_label  (label) UNIQUE
#
class ScheduleSnapshot < ApplicationRecord
  validates_presence_of :label

  has_many :person_schedule_snapshots, dependent: :destroy
  has_one :schedule_workflow

  enum status: {
    not_set: 'not_set',
    in_progress: 'in_progress',
    done: 'done',
    failed: 'failed'
  }
end

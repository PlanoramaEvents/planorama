# == Schema Information
#
# Table name: schedule_workflows
#
#  id                   :uuid             not null, primary key
#  created_by           :string
#  lock_version         :integer
#  set_at               :datetime
#  state                :enum             default("not_set")
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  schedule_snapshot_id :uuid
#
# Indexes
#
#  index_schedule_workflows_on_schedule_snapshot_id  (schedule_snapshot_id) UNIQUE
#
class ScheduleWorkflow < ApplicationRecord
  belongs_to :schedule_snapshot, required: false, dependent: :destroy

  has_many  :person_schedule_approvals, dependent: :destroy

  enum state: {
    not_set: 'not_set',
    draft: 'draft',
    firm: 'firm'
  }
end

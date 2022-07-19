class ScheduleWorkflow < ApplicationRecord
  belongs_to :schedule_snapshot, required: false, dependent: :destroy

  has_many  :person_schedule_approvals, dependent: :destroy

  enum state: {
    not_set: 'not_set',
    draft: 'draft',
    firm: 'firm'
  }
end

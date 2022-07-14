class ScheduleWorkflow < ApplicationRecord
  # validates :membership_number, presence: true, uniqueness: true
  belongs_to :schedule_snapshot

  has_many  :person_schedule_approvals, dependent: :destroy

  enum state: {
    not_set: 'not_set',
    draft: 'draft',
    firm: 'firm'
  }
end

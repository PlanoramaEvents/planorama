class PersonScheduleApproval < ApplicationRecord
  belongs_to :person
  belongs_to :schedule_workflow

  enum approved: {
    not_set: 'not_set',
    yes: 'yes',
    no: 'no'
  }
end

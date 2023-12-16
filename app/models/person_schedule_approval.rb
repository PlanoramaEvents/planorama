# == Schema Information
#
# Table name: person_schedule_approvals
#
#  id                   :uuid             not null, primary key
#  approved             :enum             default("not_set")
#  comments             :text
#  lock_version         :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  person_id            :uuid
#  schedule_workflow_id :uuid
#
# Indexes
#
#  psa_person_wrkflw_idx  (person_id,schedule_workflow_id) UNIQUE
#
class PersonScheduleApproval < ApplicationRecord
  belongs_to :person
  belongs_to :schedule_workflow

  enum approved: {
    not_set: 'not_set',
    yes: 'yes',
    no: 'no'
  }
end

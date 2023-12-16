# == Schema Information
#
# Table name: person_schedule_snapshots
#
#  id                   :uuid             not null, primary key
#  lock_version         :integer
#  snapshot             :jsonb
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  person_id            :uuid
#  schedule_snapshot_id :uuid
#
class PersonScheduleSnapshot < ApplicationRecord
  belongs_to :schedule_snapshot
  belongs_to :person
end

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
class ScheduleSnapshotSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :created_at, :updated_at,
             :label, :created_by, :started_at, :completed_at,
             :status
end

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
class ScheduleWorkflowSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :created_at, :updated_at,
             :created_by, :set_at, :state, :schedule_snapshot_id

  attribute :label do |obj|
    obj.schedule_snapshot&.label
  end

  # snapshot information
  has_one :schedule_snapshot, lazy_load_data: true, serializer: ScheduleSnapshotSerializer,
          links: {
           self: -> (object, params) {
             "#{params[:domain]}/schedule_workflow/#{object.id}"
           },
           related: -> (object, params) {
             "#{params[:domain]}/schedule_snapshot/#{object.schedule_snapshot_id}"
           }
         }
end

class Conflicts::SessionConflictSerializer
  include JSONAPI::Serializer

  attribute :id, :title, :start_time

  has_many :availability_conflicts, serializer: Conflicts::AvailabilityConflictSerializer do |record|
    # we need to do this to get the serializer to handle the composite id properly...
    record.availability_conflicts
  end

  has_many :assigned_rooms, serializer: RoomSerializer,
            links: {
              self: -> (object, params) {
                "#{params[:domain]}/session/#{object.id}"
              },
              related: -> (object, params) {
                "#{params[:domain]}/session/#{object.id}/assigned_rooms"
              }
            }
end

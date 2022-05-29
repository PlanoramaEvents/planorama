class Conflicts::SessionConflictSerializer
  include JSONAPI::Serializer

  attribute :id, :title, :start_time

  has_one :room, serializer: ::RoomSerializer,
          if: Proc.new { |record| record.room },
          links: {
            self: -> (object, params) {
              "#{params[:domain]}/session/#{object.id}"
            },
            related: -> (object, params) {
              "#{params[:domain]}/room/#{object.room.id}"
            }
          }

  has_many :availability_conflicts, serializer: Conflicts::AvailabilityConflictSerializer do |record|
    # we need to do this to get the serializer to handle the composite id properly...
    record.availability_conflicts
  end
end

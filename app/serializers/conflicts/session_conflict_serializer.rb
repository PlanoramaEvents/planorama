class Conflicts::SessionConflictSerializer
  include JSONAPI::Serializer

  attribute :id, :title

  has_many :availability_conflicts, serializer: Conflicts::AvailabilityConflictSerializer do |record|
    # we need to do this to get the serializer to handle the composite id properly...
    record.availability_conflicts
  end
end

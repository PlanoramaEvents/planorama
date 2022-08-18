class PublicationDateSerializer
  include JSONAPI::Serializer

  attributes :id, :created_at, :updated_at, :timestamp,
             :new_sessions, :updated_sessions, :dropped_sessions,
             :new_assignments, :updated_assignments, :dropped_assignments,
             :sent_external
end

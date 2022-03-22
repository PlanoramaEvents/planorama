class MailTemplateSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :created_at, :updated_at,
             :subject, :content,
             :transiton_person_status

end

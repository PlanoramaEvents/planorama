class MailTemplateSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :created_at, :updated_at,
             :title, :subject, :content,
             :transiton_invite_status #, :mail_use

end

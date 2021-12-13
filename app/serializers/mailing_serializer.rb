class MailingSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :created_at, :updated_at,
             :testrun, :include_email, :cc_all,
             :mailing_state, :title,
             :last_person_idx,
             :date_sent, :subject, :content,
             :display_name,
             :transiton_invite_status

  belongs_to :survey
  has_many :people
end

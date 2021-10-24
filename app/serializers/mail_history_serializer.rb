class MailHistorySerializer
  include JSONAPI::Serializer

  # set id?
  attributes :id, :lock_version,
             :email_status, :date_sent, :email,
             :content, :testrun, :subject,
             :created_at, :updated_at

  # TODO
  # belongs_to :person_mailing_assignment
  # belongs_to :person
  # belongs_to :mailing
end

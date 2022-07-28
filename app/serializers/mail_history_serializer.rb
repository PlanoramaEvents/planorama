class MailHistorySerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version,
             :email_status, :date_sent,
             :content, :testrun, :subject,
             :created_at, :updated_at

  # This is because the email can be an array of emails
  attribute :email do |object|
    JSON.parse object.email
  end
  # belongs_to :person_mailing_assignment
  # belongs_to :person
  # belongs_to :mailing
end

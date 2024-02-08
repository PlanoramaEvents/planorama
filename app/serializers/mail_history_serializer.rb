# == Schema Information
#
# Table name: mail_histories
#
#  id                           :uuid             not null, primary key
#  content                      :text
#  date_sent                    :datetime
#  email                        :string
#  email_status                 :enum
#  lock_version                 :integer          default(0)
#  subject                      :string
#  testrun                      :boolean          default(FALSE)
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  mailing_id                   :uuid
#  person_id                    :uuid
#  person_mailing_assignment_id :uuid
#
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

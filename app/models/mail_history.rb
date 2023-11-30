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
class MailHistory < ApplicationRecord
  belongs_to :person, optional: true
  belongs_to :mailing, optional: true

  enum email_status: {
    pending: 'pending',
    sent: 'sent',
    failed: 'failed'
  }
end

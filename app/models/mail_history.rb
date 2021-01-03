class MailHistory < ApplicationRecord
  belongs_to :person_mailing_assignment
  belongs_to :person
  belongs_to :mailing

  enum email_status: {
    pending: 'Pending',
    sent: 'Sent',
    failed: 'Failed'
  }
end

class MailHistory < ApplicationRecord
  belongs_to :person, optional: true
  belongs_to :mailing, optional: true

  enum email_status: {
    pending: 'pending',
    sent: 'sent',
    failed: 'failed'
  }
end

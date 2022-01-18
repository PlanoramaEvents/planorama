class Mailing < ApplicationRecord
  has_many  :person_mailing_assignments, dependent: :destroy
  has_many  :people, through: :person_mailing_assignments
  has_many  :mail_histories, dependent: :destroy

  # has_many :email_addresses, through: :people
  has_many :primary_email, through: :people

  belongs_to :survey, optional: true
  belongs_to :sent_by, class_name: 'Person', required: false

  enum mailing_state: {
    draft: 'draft',
    submitted: 'submitted',
    sent: 'sent'
  }

  def display_name
    title_part = "[#{title}]" if title.present? && title != subject
    subject_part = subject || 'No Subject'
    [title_part, subject_part].join(' ').strip
  end
end

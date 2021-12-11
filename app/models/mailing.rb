class Mailing < ApplicationRecord
  has_many  :person_mailing_assignments, dependent: :destroy
  has_many  :people, through: :person_mailing_assignments
  has_many  :mail_histories, dependent: :destroy

  belongs_to :mail_template, touch: true, dependent: :destroy

  has_one  :survey, through: :mail_template

  enum mailing_state: {
    draft: 'draft',
    submitted: 'submitted',
    sent: 'sent'
  }

  def date_sent
    mail_histories.any? ? mail_histories.pluck(:date_sent).last : nil
  end

  def subject
    mail_template ? mail_template.subject : nil
  end

  def content
    mail_template ? mail_template.content : nil
  end

  def transition_invite_status_id
    mail_template ? mail_template.transiton_invite_status_id : nil
  end

  def display_name
    title_part = "[#{title}]" if title.present? && title != subject
    subject_part = subject || 'No Subject'
    [title_part, subject_part].join(' ').strip
  end
end

class Mailing < ApplicationRecord
  has_many  :person_mailing_assignments, dependent: :destroy
  has_many  :people, through: :person_mailing_assignments
  has_many  :mail_histories, dependent: :destroy

  belongs_to :mail_template, touch: true, dependent: :destroy

  validate :number_and_mail_use_unique

  def date_sent
    mail_histories.any? ? mail_histories.pluck(:date_sent).last : nil
  end

  # Make sure that the combination of number and mail_use_id is unique
  def number_and_mail_use_unique
    Mailing.references(:mail_template)
           .includes(:mail_template)
           .where(
             [
               'mailing_number = ? AND mail_templates.mail_use_id = ?',
               mailing_number, mail_template.mail_use_id
             ]
           ).first

    errors.add(:mailing_number, 'Unique-mailing-error') if m != nil && m.id != id
  end

  def title
    mail_template ? mail_template.title : nil
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
    [title_part, subject_part].join(' ')
  end
end

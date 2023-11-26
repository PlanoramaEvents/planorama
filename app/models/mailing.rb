# == Schema Information
#
# Table name: mailings
#
#  id                      :uuid             not null, primary key
#  cc_all                  :boolean          default(FALSE)
#  content                 :text
#  date_sent               :datetime
#  description             :text
#  include_email           :boolean          default(TRUE)
#  last_person_idx         :integer          default(-1)
#  lock_version            :integer          default(0)
#  mailing_state           :enum             default("draft")
#  subject                 :string
#  testrun                 :boolean          default(FALSE)
#  title                   :string
#  transiton_person_status :enum
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  sent_by_id              :uuid
#  survey_id               :uuid
#
# Indexes
#
#  index_mailings_on_mailing_state  (mailing_state)
#
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

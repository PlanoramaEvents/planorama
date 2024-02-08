# == Schema Information
#
# Table name: person_mailing_assignments
#
#  id           :uuid             not null, primary key
#  lock_version :integer          default(0)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  mailing_id   :uuid
#  person_id    :uuid
#
# Indexes
#
#  index_person_mailing_assignments_on_mailing_id  (mailing_id)
#  index_person_mailing_assignments_on_person_id   (person_id)
#
class PersonMailingAssignment < ApplicationRecord
  belongs_to  :person
  belongs_to  :mailing

  # has_many :mail_histories
end

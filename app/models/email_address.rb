# == Schema Information
#
# Table name: email_addresses
#
#  id           :uuid             not null, primary key
#  email        :string           default("")
#  is_valid     :boolean          default(TRUE), not null
#  iscontact    :boolean          default(FALSE)
#  isdefault    :boolean          default(FALSE), not null
#  label        :string
#  lock_version :integer          default(0)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  person_id    :uuid
#
# Indexes
#
#  index_email_addresses_on_email  (email) USING gin
#
class SinglePrimaryEmail < ActiveModel::Validator
  def validate(record)
    emails = EmailAddress.where(isdefault: true, email: record.email).where("person_id != ?", record.person_id)
    if record.isdefault && emails.any?
      record.errors.add(
        :email,
        "That Primary Email address is already in use"
      )
    end
  end
end


class EmailAddress < ApplicationRecord
  belongs_to :person

  before_save :strip_spaces
  after_save  :check_default, :check_contact

  has_paper_trail versions: { class_name: 'Audit::PersonVersion' }, ignore: [:updated_at, :created_at, :lock_version]

  validates_with SinglePrimaryEmail

  def strip_spaces
    email.strip!
  end

  # if this is the default then make the others non default (for the person)
  def check_default
    return unless isdefault

    EmailAddress
      .where(['person_id = ? AND id != ?', person_id, id])
      .update_all('isdefault = false')
  end

  def check_contact
    return unless iscontact

    EmailAddress
      .where(['person_id = ? AND id != ?', person_id, id])
      .update_all('iscontact = false')
  end
end

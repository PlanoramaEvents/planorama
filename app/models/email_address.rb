class SinglePrimaryEmail < ActiveModel::Validator
  def validate(record)
    if record.isdefault && EmailAddress.where(isdefault: true, email: record.email).any?
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

  has_paper_trail versions: { class_name: 'Audit::PersonVersion' }, ignore: [:updated_at, :created_at]

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

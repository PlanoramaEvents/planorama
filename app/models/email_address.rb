class EmailAddress < ApplicationRecord
  belongs_to :person

  before_save :strip_spaces
  after_save  :check_default, :check_contact

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

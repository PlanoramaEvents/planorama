class PhoneNumber < ApplicationRecord
  has_one :person

  enum phone_type: {
    home: 'Home',
    mobile: 'Mobile',
    work: 'Work',
    fax: 'Fax',
    other: 'Other'
  }

  after_save :check_default

  private

  def check_default
    return unless isdefault # if this is the default then make the others non default (for the person)

    PhoneNumber
      .where(['person_id = ? && id != ?', person_id, id])
      .update_all('phone_numbers.isdefault = 0')
  end
end

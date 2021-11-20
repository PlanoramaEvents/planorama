class PersonMailingAssignment < ApplicationRecord
  belongs_to  :person
  belongs_to  :mailing

  # has_many :mail_histories
end

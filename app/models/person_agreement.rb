class PersonAgreement < ApplicationRecord
  belongs_to :person
  belongs_to :agreement
end

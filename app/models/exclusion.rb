class Exclusion < ApplicationRecord
  belongs_to  :person
  belongs_to  :excludable, polymorphic: true
end

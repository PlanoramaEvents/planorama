class Bio < ApplicationRecord
  belongs_to :person

  #
  # TODO: add in profile picture capability. Use shrine and some storga engine?
  #
end

# 
# This is a table that contains the information that we got from
# the convenstions registration system ...
# 
class RegistrationSyncDatum < ApplicationRecord
  has_many :registration_sync_matches,
           class_name: 'Registration::RegistrationSyncMatch',
           foreign_key: 'rid'

  # limit the matches ...?
  # Add index of reg_id to people
  # where reg_id not in people.reg_id

  has_many :people, through: :registration_sync_matches
end

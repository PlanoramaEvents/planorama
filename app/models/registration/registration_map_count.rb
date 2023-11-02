# This uses a View to count the potential map from
# reg to people using names and/or email
# For each unique person reg data pair it counts the number of matches
# ideally there should be 2 (one for email and one for name)
class Registration::RegistrationMapCount < ApplicationRecord
  self.table_name = :registration_map_counts
  self.primary_keys = :reg_id, :pid

  belongs_to :person, optional: true, foreign_key: 'pid'
  belongs_to :registration_sync_datum, optional: true, foreign_key: 'reg_id'
end

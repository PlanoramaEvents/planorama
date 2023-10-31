class Registration::RegistrationSyncMatch < ApplicationRecord
  self.table_name = :registration_sync_matches
  self.primary_keys = :rid, :mtype

  belongs_to :person, optional: true, foreign_key: 'pid'
  belongs_to :registration_sync_datum, optional: true, foreign_key: 'rid'
end

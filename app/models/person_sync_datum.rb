# This links the person to possible matches from the
# registration system
class PersonSyncDatum < Person
  has_many :registration_sync_matches,
           class_name: 'Registration::RegistrationSyncMatch',
           foreign_key: 'pid'

  has_many :registration_sync_data, through: :registration_sync_matches
end
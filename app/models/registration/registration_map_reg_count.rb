# 
# Count of how many matches there are per reg id based on the map_reg count
#  if > 1 then there are multiple potential reg data mapped to same person
# 
class Registration::RegistrationMapRegCount < ApplicationRecord
  self.table_name = :registration_map_reg_counts
  self.primary_keys = :reg_id

  belongs_to :registration_sync_datum, foreign_key: 'reg_id'
end

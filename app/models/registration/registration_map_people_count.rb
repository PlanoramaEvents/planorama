# 
# Count of how many matches there are per person id based on the map_reg count
#  if > 1 then there are multiple potential people mapped to same reg id
#
class Registration::RegistrationMapPeopleCount < ApplicationRecord
  self.table_name = :registration_map_people_counts
  self.primary_keys = :pid

  belongs_to :person, foreign_key: 'pid'
end

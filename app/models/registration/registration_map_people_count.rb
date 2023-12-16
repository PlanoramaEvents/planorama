# == Schema Information
#
# Table name: registration_map_people_counts
#
#  count :bigint
#  pid   :uuid             primary key
#
class Registration::RegistrationMapPeopleCount < ApplicationRecord
  self.table_name = :registration_map_people_counts
  self.primary_keys = :pid

  belongs_to :person, foreign_key: 'pid'
end

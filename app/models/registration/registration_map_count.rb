# == Schema Information
#
# Table name: registration_map_counts
#
#  pid       :uuid             primary key
#  sub_count :bigint
#  reg_id    :string           primary key
#
class Registration::RegistrationMapCount < ApplicationRecord
  self.table_name = :registration_map_counts
  self.primary_keys = :reg_id, :pid

  belongs_to :person, optional: true, foreign_key: 'pid'
  belongs_to :registration_sync_datum, optional: true, foreign_key: 'reg_id'
end

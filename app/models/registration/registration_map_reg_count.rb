# == Schema Information
#
# Table name: registration_map_reg_counts
#
#  count  :bigint
#  reg_id :string           primary key
#
class Registration::RegistrationMapRegCount < ApplicationRecord
  self.table_name = :registration_map_reg_counts
  self.primary_keys = :reg_id

  belongs_to :registration_sync_datum, foreign_key: 'reg_id'
end

# == Schema Information
#
# Table name: registration_sync_data
#
#  id                  :uuid             not null, primary key
#  alternative_email   :string
#  badge_name          :string
#  email               :string
#  lock_version        :integer
#  name                :string
#  preferred_name      :string
#  raw_info            :jsonb            not null
#  registration_number :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  reg_id              :string
#
# Indexes
#
#  index_registration_sync_data_on_alternative_email    (alternative_email) USING gin
#  index_registration_sync_data_on_badge_name           (badge_name) USING gin
#  index_registration_sync_data_on_email                (email) USING gin
#  index_registration_sync_data_on_name                 (name) USING gin
#  index_registration_sync_data_on_preferred_name       (preferred_name) USING gin
#  index_registration_sync_data_on_reg_id               (reg_id)
#  index_registration_sync_data_on_registration_number  (registration_number)
#
class RegistrationSyncDatum < ApplicationRecord
  has_many :registration_sync_matches,
           class_name: 'Registration::RegistrationSyncMatch',
           foreign_key: 'rid'

  # limit the matches ...?
  # Add index of reg_id to people
  # where reg_id not in people.reg_id
  has_one :matched_person,
          class_name: 'Person',
          foreign_key: 'reg_id',
          primary_key: 'reg_id'

  has_many :people, through: :registration_sync_matches
end

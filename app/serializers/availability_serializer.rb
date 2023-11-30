# == Schema Information
#
# Table name: availabilities
#
#  id           :uuid             not null, primary key
#  end_time     :datetime
#  lock_version :integer
#  start_time   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  person_id    :uuid
#
class AvailabilitySerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :created_at, :updated_at,
             :start_time, :end_time, :person_id
end

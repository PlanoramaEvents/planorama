# == Schema Information
#
# Table name: session_limits
#
#  id           :uuid             not null, primary key
#  day          :date
#  lock_version :integer
#  max_sessions :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  person_id    :uuid
#
# Indexes
#
#  index_session_limits_on_person_id          (person_id)
#  index_session_limits_on_person_id_and_day  (person_id,day) UNIQUE
#
class SessionLimitSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :created_at, :updated_at,
             :person_id, :day, :max_sessions

  belongs_to :person,
            if: Proc.new { |record| record.person_id },
            links: {
              self: -> (object, params) {
                "#{params[:domain]}/session_limit/#{object.id}"
              },
              related: -> (object, params) {
                "#{params[:domain]}/person/#{object.person_id}"
              }
            }
end

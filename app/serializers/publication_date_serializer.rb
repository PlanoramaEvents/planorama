# == Schema Information
#
# Table name: publication_dates
#
#  id                  :uuid             not null, primary key
#  dropped_assignments :integer          default(0)
#  dropped_sessions    :integer          default(0)
#  lock_version        :integer          default(0)
#  new_assignments     :integer          default(0)
#  new_sessions        :integer          default(0)
#  sent_external       :boolean          default(FALSE), not null
#  timestamp           :datetime
#  updated_assignments :integer          default(0)
#  updated_sessions    :integer          default(0)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
class PublicationDateSerializer
  include JSONAPI::Serializer

  attributes :id, :created_at, :updated_at, :timestamp,
             :new_sessions, :updated_sessions, :dropped_sessions,
             :new_assignments, :updated_assignments, :dropped_assignments,
             :sent_external, :lock_version
end

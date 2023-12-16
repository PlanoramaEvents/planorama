# == Schema Information
#
# Table name: person_schedules
#
#  id                              :text             primary key
#  can_share                       :boolean
#  con_state                       :enum
#  description                     :text
#  duration                        :integer
#  end_time                        :datetime
#  environment                     :enum
#  name                            :string
#  participant_notes               :text
#  pronouns                        :string(400)
#  published_name                  :string
#  session_assignment_name         :string(100)
#  session_assignment_role_type    :enum
#  sort_order                      :integer
#  start_time                      :datetime
#  status                          :enum
#  title                           :string(256)
#  updated_at                      :datetime
#  format_id                       :uuid
#  person_id                       :uuid
#  room_id                         :uuid
#  session_assignment_id           :uuid
#  session_assignment_role_type_id :uuid
#  session_id                      :uuid
#
class PersonScheduleSerializer

  include JSONAPI::Serializer

  attributes :id, :name, :published_name, :con_state, :pronouns,
             :session_assignment_name,
             :title, :start_time, :end_time, :duration,
             :participant_notes, :description, :environment

  attribute :areas do |object|
    object.area_list.sort{ |a, b| a.downcase <=> b.downcase }
  end

  attribute :format do |object|
    object.format ? object.format.name : nil
  end

  attribute :room do |object|
    object.room ? object.room.name : nil
  end

  # Check if person is included in here
  attribute :moderators do |object|
    object.moderators.collect{|p| {published_name: p.published_name, email: p.can_share ? p.primary_email&.email : nil, pronouns: p.pronouns}}
  end

  attribute :participants do |object|
    object.participants.collect{|p| {published_name: p.published_name, email: p.can_share ? p.primary_email&.email : nil, pronouns: p.pronouns}}
  end

  attribute :invisibles do |object|
    object.invisibles.collect{|p| {published_name: p.published_name, email: p.can_share ? p.primary_email&.email : nil, pronouns: p.pronouns}}
  end
end

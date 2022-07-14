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
    object.moderators.collect{|p| {published_name: p.published_name, email: p.can_share ? p.email: nil}}
  end

  attribute :participants do |object|
    object.participants.collect{|p| {published_name: p.published_name, email: p.can_share ? p.email: nil}}
  end

  attribute :invisibles do |object|
    object.invisibles.collect{|p| {published_name: p.published_name, email: p.can_share ? p.email: nil}}
  end
end

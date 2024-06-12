class Conclar::SessionSerializer < ActiveModel::Serializer
  attributes :title

  attribute :format do    
    object.format.name if object.format
  end

  attribute :id do
    if object.has_attribute?(:id)
      object.id
    else
      object.session_id
    end
  end

  attribute :desc do
    object.description
  end

  attribute :datetime do
    object.start_time
  end

  attribute :areas do |session|
    res = []

    object.area_list.each do |area|
      a = {
        value: "session_".concat(area),
        category: "Area",
        label: area
      }
      res << a
    end

    res
  end

  attribute :tags do
    res = []
    
    res = object.taggings.select{|t| t.context == 'tags'}.collect(&:tag).collect{|t|
      {
        value: "tag_".concat(t.name.gsub(/\s/,'_')),
        category: "Tag",
        label: t.name
      }      
    }

    case object.environment
    when 'in_person'
      t = {
        value: "session_".concat(object.environment),
        category: "Environment",
        label: 'In Person'
      }
      res << t
    when 'hybrid'
      t = {
        value: "session_".concat(object.environment),
        category: "Environment",
        label: 'Hybrid'
      }
      res << t
    when 'virtual'
      t = {
        value: "session_".concat(object.environment),
        category: "Environment",
        label: 'Online'
      }
      res << t
    else
    end

    if object.age_restriction
      t = {
        value: "session_".concat(object.age_restriction.name),
        category: "Note",
        label: object.age_restriction.name
      }
      res << t
    end

    if object.require_signup
      t = {
        value: "session_require_signup",
        category: "Note",
        label: "Requires Signup"
      }
      res << t
    end

    if object.recorded
      t = {
        value: "session_recorded",
        category: "Note",
        label: "Recorded"
      }
      res << t
    end

    if object.streamed
      t = {
        value: "session_streamed",
        category: "Environment",
        label: "Streamed"
      }
      res << t
    end

    res
  end
  
  attribute :mins do
    object.duration
  end

  attribute :loc do
     # [ "Some Room", "Some Area" ],
    if object.room
      # [object.room.name, object.room.venue.name]
      [object.room.name]
    else
      []
    end
  end

  # links is an array that contains a set of url links for the programme item.
  # Currently, signup, meeting and recording are the valid link types.
  attribute :links do
    if instance_options[:g24rce]
      if object.environment == 'virtual' || object.streamed
        if object.room.integrations["rce"] && object.room.integrations["rce"]["SegmentType"]
          if object.room.integrations["rce"]["SegmentType"] == "stage"
            {
              meeting: "#{instance_options[:g24rce]}deep-link/stage?room_id=#{object.room.id}",
              chat: "#{instance_options[:g24rce]}deep-link/chat?room_id=#{object.room.id}",
              recording: "#{instance_options[:g24rce]}deep-link/replay?item_id=#{object.id}"
            }
          else # session
            {
              meeting: "#{instance_options[:g24rce]}deep-link/session?item_id=#{object.id}",
              chat: "#{instance_options[:g24rce]}deep-link/chat?item_id=#{object.id}",
              recording: "#{instance_options[:g24rce]}deep-link/replay?item_id=#{object.id}"
            }
          end
        end
      end
    end
  end

  attribute :people do
    moderator = SessionAssignmentRoleType.find_by(name: 'Moderator')
    invisible = SessionAssignmentRoleType.find_by(name: 'Invisible')
    parts = []
    object.participant_assignments.each do |assignment|
      next if assignment.session_assignment_role_type_id == invisible.id

      p = {
        id: assignment.person.id,
        name: assignment.person.published_name
        # role: nil
      }
      p['role'] = 'moderator' if assignment.session_assignment_role_type_id == moderator.id
      parts << p
    end

    parts
  end
end

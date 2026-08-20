class Conclar::SessionSerializer < ActiveModel::Serializer
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

  attribute :title do
    if object.title
      object.title
              .gsub(/(&nbsp;)+/, " ")
              .gsub("\u200B", "") # unlikely
              .gsub("\uFEFF", "") # unlikely
              .gsub(/\r\n?/, "\n")
              .gsub(/[ \t]+\n/, "\n")
              .gsub(/\n{3,}/, "\n\n")
              .gsub(/ {2,}/, " ")
              .strip
    else
      object.title
    end
  end

  attribute :desc do
    if object.description
      object.description
              .gsub(/(&nbsp;)+/, " ")
              .gsub("\u200B", "") # unlikely
              .gsub("\uFEFF", "") # unlikely
              .gsub(/\r\n?/, "\n")
              .gsub(/[ \t]+\n/, "\n")
              .gsub(/\n{3,}/, "\n\n")
              .gsub(/ {2,}/, " ")
              .strip
    else
      object.description
    end
  end

  attribute :datetime do
    object.start_time
  end

  attribute :tags do
    res = []
    
    object.taggings.select{|t| t.context == 'tags'}.collect(&:tag).collect{|t|
      t = {
        value: "tag_".concat(t.name.gsub(/\s/,'_')),
        category: "Tag",
        label: t.name
      }
      res << t
    }

    object.area_list.each do |area|
      a = {
        value: "session_".concat(area),
        category: "Area",
        label: area
      }
      res << a
    end

    env_tag = nil
    if object.room && object.room.integrations['zoom']
      if (object.room.integrations['zoom']['virtual_room'] == true || object.room.integrations['zoom']['virtual_room'] == 'true') || object.room.integrations['zoom']['meeting_type'] == 'discord'
        env_tag = {
          value: "session_online",
          category: "Environment",
          label: 'Virtual'
        }
      end
    end
    if env_tag.nil?
      case object.environment
      when 'in_person'
        env_tag = {
          value: "session_in_person",
          category: "Environment",
          label: 'In Person'
        }
      when 'hybrid'
        env_tag = {
          value: "session_in_person",
          category: "Environment",
          label: 'In Person'
        }
      when 'virtual'
        env_tag = {
          value: "session_online",
          category: "Environment",
          label: 'Virtual'
        }
      else
      end
    end

    res << env_tag if env_tag

    if object.age_restriction
      t = {
        value: "session_".concat(object.age_restriction.name),
        category: "Availability",
        label: object.age_restriction.name
      }
      res << t
    end

    if object.require_signup
      t = {
        value: "session_require_signup",
        category: "Availability",
        label: "Requires Signup"
      }
      res << t
    end

    if object.recorded
      t = {
        value: "session_replay",
        category: "Availability",
        label: "Recorded"
      }
      res << t
    else
      t = {
        value: "session_no_replay",
        category: "Availability",
        label: "Not Recorded"
      }
      res << t
    end

    streamed_room = (object.room.integrations['zoom'] && (object.room.integrations['zoom']['virtual_room'] == true || object.room.integrations['zoom']['virtual_room'] == 'true' || object.room.integrations['zoom']['meeting_type'] == 'discord'))
    # If a "zoom" room is in one of these formats then it is not streamed to the public
    # i.e. only the attendees participate and can see what is happening
    # if object.format
    #   streamed_zoom &&= ['Reading','Table Talk','Workshop','Party','Discussion Circle','Meetup'].exclude?  object.format.name
    # end

    if object.streamed || streamed_room
      t = {
        value: "session_streamed",
        category: "Availability",
        label: 'Streamed'
      }
      res << t
    else
      t = {
        value: "session_not_streamed",
        category: "Availability",
        label: 'Not Streamed'
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
    if instance_options[:base_url]
      res = {}
      if object.environment == 'virtual' || object.streamed || object.integrations['zoom_session_id']
        if object.room.integrations["rce"] && object.room.integrations["rce"]["SegmentType"]
          res = if object.room.integrations["rce"]["SegmentType"] == "stage"
            {
              stage: "#{instance_options[:base_url]}/deep-link/stage?room_id=#{object.room.id}",
            }
          else # session
            {
              session: "#{instance_options[:base_url]}/deep-link/session?item_id=#{object.id}"
            }
          end
        elsif PortalService.portal_enabled
          if object.environment == 'virtual' || object.streamed || 
                (object.room.integrations['zoom'] && object.room.integrations['zoom']['meeting_type'] != 'discord')
            # check room for watch key
            if ['07254308-9339-43ce-856a-bd8fc305428a', '85325568-8608-4bed-92fe-7ceb33c5d8c4'].include?  object.room.id
              res[:join] = "#{instance_options[:base_url]}/deep-link/session?item_id=#{object.id}"
            else
              res[:watch] = "#{instance_options[:base_url]}/deep-link/session?item_id=#{object.id}"
            end
            res[:recording] = "#{instance_options[:base_url]}/deep-link/replay?item_id=#{object.id}" if object.recorded        
          end
          if object.room.integrations['zoom'] && object.room.integrations['zoom']['meeting_type'] == 'discord'
            res[:join] = "#{instance_options[:base_url]}/deep-link/chat?room_id=#{object.room.id}&item_id=#{object.id}"
          end
        end
      end

      # Only allow chat for most formats except the excluded ones
      if ['Autographing','Dance','Filk Circle', 'Game', 'Reception', 'Table Talk', ].exclude?  object.format.name
        res[:chat] = "#{instance_options[:base_url]}/deep-link/chat?room_id=#{object.room.id}&item_id=#{object.id}"
      end

      res[:signup] = "#{instance_options[:base_url]}/signups" if object.require_signup
      res
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

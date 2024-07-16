class Conclar::ParticipantSerializer < ActiveModel::Serializer
  attributes :id, :bio

  attribute :name do
    object.published_name
  end

  attribute :sortname do
    object.published_name_sort_by
  end

  attribute :prog do
    res = []
    # TODO: change when we have publish process ???
    if object.published_session_assignments.count > 0
      moderator = SessionAssignmentRoleType.find_by(name: 'Moderator')
      participant = SessionAssignmentRoleType.find_by(name: 'Participant')

      object.published_session_assignments.each do |assignment|
        next if assignment.session_assignment_role_type_id != moderator.id and assignment.session_assignment_role_type_id != participant.id

        res << assignment.published_session_id
      end
    else
      object.sessions.publishable.each do |session|
        res << session.id
      end
    end

    res
  end

  attribute :links do
    res = {}

    res['twitter'] = "https://twitter.com/#{object.twitter}" unless object.twitter.blank?
    res['facebook'] = "https://facebook.com/#{object.facebook}" unless object.facebook.blank?
    res['website'] = object.website unless object.website.blank?
    res['instagram'] = "https://instagram.com/#{object.instagram}" unless object.instagram.blank?
    res['twitch'] = "https://twitch.tv/#{object.twitch}" unless object.twitch.blank?
    res['youtube'] = "https://youtube.com/#{object.youtube}" unless object.youtube.blank?
    res['tiktok'] = "https://www.tiktok.com/@#{object.tiktok}" unless object.tiktok.blank?
    res['linkedin'] = "https://linkedin.com/in/#{object.linkedin}" unless object.linkedin.blank?
    res['othersocialmedia'] = object.othersocialmedia unless object.othersocialmedia.blank?
    res['fediverse'] = object.fediverse unless object.fediverse.blank?
    res['bsky'] = "https://bsky.app/profile/#{object.bsky}" unless object.bsky.blank?

    res
  end

  # tags
  attribute :tags do
    res = []

    case object.attendance_type
    when 'in_person'
      t = {
        value: "person_".concat(object.attendance_type),
        category: "Attendance",
        label: 'In Person'
      }
      res << t
    when 'hybrid'
      t = {
        value: "person_".concat(object.attendance_type),
        category: "Attendance",
        label: 'Hybrid'
      }
      res << t
    when 'virtual'
      t = {
        value: "person_".concat(object.attendance_type),
        category: "Attendance",
        label: 'Virtual'
      }
      res << t
    else
    end

    res
  end
end

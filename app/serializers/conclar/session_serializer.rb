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

  # TODO: change for when we do have tags
  attribute :tags do
    res = []

    object.area_list.each do |area|
      a = {
        value: "session_".concat(area),
        category: "Area",
        label: area
      }
      res << a
    end


    #res.concat ["Environment: ".concat( object.environment )] if object.environment != 'unknown' # virtual hybrid etc
    if object.environment != 'unknown'    # virtual hybrid etc
      t = {
        value: "session_".concat(object.environment),
        category: "Environment",
        label: object.environment
      }
      res << t
    end

    #if object.minors_participation && object.minors_participation.class == Array
    #  res.concat object.minors_participation.collect { |x| "Minors Participation: " + x }
    #end

    #res.concat ["Note: ".concat( object.age_restriction.name )] if object.age_restriction
    if object.age_restriction
      t = {
        value: "session_".concat(object.age_restriction.name),
        category: "Note",
        label: object.age_restriction.name
      }
      res << t
    end
    #res.concat ['Note: Require Signup'] if object.require_signup
    if object.require_signup
      t = {
        value: "session_require_signup",
        category: "Note",
        label: "Require Signup"
      }
      res << t
    end
    #res.concat ['Note: Recorded'] if object.recorded
    if object.recorded
      t = {
        value: "session_recorded",
        category: "Note",
        label: "Recorded"
      }
      res << t
    end
    #res.concat ['Note: Streamed'] if object.streamed
    if object.streamed
      t = {
        value: "session_streamed",
        category: "Note",
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
      [object.room.name, object.room.venue.name]
    else
      []
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

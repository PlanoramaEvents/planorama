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

    res.concat object.area_list.collect { |x| "Area: " + x }
    res.concat ["Environment: ".concat( object.environment )] if object.environment != 'unknown' # virtual hybrid etc

    #if object.minors_participation && object.minors_participation.class == Array
    #  res.concat object.minors_participation.collect { |x| "Minors Participation: " + x }
    #end

    res.concat ["Note: ".concat( object.age_restriction.name )] if object.age_restriction
    res.concat ['Note: Require Signup'] if object.require_signup
    res.concat ['Note: Recorded'] if object.recorded
    res.concat ['Note: Streamed'] if object.streamed

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

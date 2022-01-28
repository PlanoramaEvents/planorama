class SessionsController < ResourceController
  SERIALIZER_CLASS = 'SessionSerializer'.freeze
  POLICY_CLASS = 'SessionPolicy'.freeze
  POLICY_SCOPE_CLASS = 'SessionPolicy::Scope'.freeze
  # DEFAULT_SORTBY = 'name_sort_by'

  def serializer_includes
    [
      :format,
      :room,
      # :area,
      :session_assignments,
      :my_assignment
    ]
  end

  def includes
    [
      :format,
      :room,
      # :area,
      :session_assignments
    ]
  end

  def references
    [
      :format,
      :room
    ]
  end

  def allowed_params
    %i[
      id
      lock_version
      format_id
      title
      description
      duration
      minimum_people
      maximum_people
      item_notes
      pub_reference_number
      audience_size,
      participant_notes
      is_break
      start_time,
      visibility
      publish
      room_id
      area_id
    ]
  end
end

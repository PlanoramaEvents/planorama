class SessionsController < ResourceController
  SERIALIZER_CLASS = 'SessionSerializer'.freeze
  POLICY_CLASS = 'SessionPolicy'.freeze
  POLICY_SCOPE_CLASS = 'SessionPolicy::Scope'.freeze
  # DEFAULT_SORTBY = 'name_sort_by'

  def tags
    res = Session.tags_on(:tags).order(:name)

    render json: TagSerializer.new(res,
                  {
                    # include: serializer_includes,
                    params: {domain: "#{request.base_url}"}
                  }
                ).serializable_hash(),
           content_type: 'application/json'
  end

  def serializer_includes
    [
      :format,
      :room,
      :session_areas,
      :session_assignments,
      :my_assignment
    ]
  end

  def includes
    [
      :format,
      :room,
      :areas,
      :base_tags,
      :session_areas,
      :session_assignments
    ]
  end

  def references
    [
      :format,
      :room,
      :base_tags,
      :session_areas
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
      open_for_interest
      instructions_for_interest
      tag_list
      session_areas_attributes
    ]
    # Tags
    # format
    # areas
  end
end

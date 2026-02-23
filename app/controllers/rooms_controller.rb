class RoomsController < ResourceController
  SERIALIZER_CLASS = 'RoomSerializer'.freeze
  POLICY_CLASS = 'RoomPolicy'.freeze
  POLICY_SCOPE_CLASS = 'RoomPolicy::Scope'.freeze
  DEFAULT_SORTBY = 'rooms.sort_order'

  def belongs_to_param_id
    params[:venue_id]
  end

  def belong_to_class
    Venue
  end

  def belongs_to_relationship
    'rooms'
  end

  def serializer_includes
    [
      :venue
      # :room_set
    ]
  end

  def includes
    [
      :venue,
      :room_set
    ]
  end

  def references
    [
      :venue,
      :room_set
    ]
  end

  # def paginate
  #   false
  # end
  def allowed_params
    %i[
      id
      lock_version
      name
      venue_id
      capacity
      floor
      comment
      is_virtual
      open_for_schedule
      purpose
      sort_order
      integrations
      room_set_id
      area_of_space
      height
      length
      width
    ]
  end
end

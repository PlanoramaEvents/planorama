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
end

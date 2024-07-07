class RcePolicy < BasePolicy
  def participants?
    allowed?(action: :participants)
  end

  def schedule?
    allowed?(action: :schedule)
  end
end

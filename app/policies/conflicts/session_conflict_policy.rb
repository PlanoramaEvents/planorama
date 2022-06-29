class Conflicts::SessionConflictPolicy < BasePolicy
  def ignore?
    allowed?(action: :ignore)
  end

  def conflicts_with?
    allowed?(action: :conflicts_with)
  end

  def conflicts_for?
    allowed?(action: :conflicts_for)
  end
end

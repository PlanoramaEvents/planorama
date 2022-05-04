class ReportsPolicy < ApplicationPolicy
  def participant_selections?
    allowed?(action: :participant_selections)
  end

  def session_selections?
    allowed?(action: :session_selections)
  end
end

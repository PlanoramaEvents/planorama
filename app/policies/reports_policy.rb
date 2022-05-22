class ReportsPolicy < ApplicationPolicy
  def participant_selections?
    allowed?(action: :participant_selections)
  end

  def session_selections?
    allowed?(action: :session_selections)
  end

  def assigned_sessions_by_participant?
    is_admin_or_staff
  end

  def sessions_with_participants?
    is_admin_or_staff
  end
end

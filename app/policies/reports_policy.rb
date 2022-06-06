class ReportsPolicy < ApplicationPolicy
  def people_and_submissions?
    allowed?(action: :people_and_submissions)
  end

  def participant_selections?
    allowed?(action: :participant_selections)
  end

  def session_selections?
    allowed?(action: :session_selections)
  end

  def assigned_sessions_by_participant?
    allowed?(action: :assigned_sessions_by_participant)
  end

  def sessions_with_participants?
    allowed?(action: :sessions_with_participants)
  end
end

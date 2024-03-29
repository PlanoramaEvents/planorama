class Reports::SessionReportPolicy < BasePolicy
  def panels_with_too_few_people?
    allowed?(action: :panels_with_too_few_people)
  end

  def panels_with_too_many_people?
    allowed?(action: :panels_with_too_many_people)
  end

  def participants_over_session_limits?
    allowed?(action: :participants_over_session_limits)
  end

  def participants_over_con_session_limits?
    allowed?(action: :participants_over_con_session_limits)
  end

  def non_accepted_on_schedule?
    allowed?(action: :non_accepted_on_schedule)
  end

  def invited_accepted_not_scheduled?
    allowed?(action: :invited_accepted_not_scheduled)
  end

  def session_with_no_moderator?
    allowed?(action: :session_with_no_moderator)
  end

  def scheduled_session_no_people?
    allowed?(action: :scheduled_session_no_people)
  end

  def assigned_sessions_not_scheduled?
    allowed?(action: :assigned_sessions_not_scheduled)
  end

  def session_copy_edit_status?
    allowed?(action: :session_copy_edit_status)
  end

  def daily_grid?
    allowed?(action: :daily_grid)
  end

  def streamed_and_recorded?
    allowed?(action: :streamed_and_recorded)
  end

  def session_needs?
    allowed?(action: :session_needs)
  end
end

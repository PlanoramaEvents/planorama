class Reports::ProgramOpsReportPolicy < BasePolicy
  def back_of_badge?
    allowed?(action: :back_of_badge)
  end

  def virtual_people?
    allowed?(action: :virtual_people)
  end 

  def room_signs?
    allowed?(action: :room_signs)
  end

  def sign_up_sessions?
    allowed?(action: :sign_up_sessions)
  end

  def table_tents?
    allowed?(action: :table_tents)
  end

  def session_minors?
    allowed?(action: :session_minors)
  end

  def user_privileges?
    allowed?(action: :user_privileges)
  end
end

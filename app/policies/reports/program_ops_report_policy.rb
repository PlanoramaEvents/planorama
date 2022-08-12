class Reports::ProgramOpsReportPolicy < BasePolicy
  def back_of_badge?
    allowed?(action: :back_of_badge)
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

  def user_privileges?
    allowed?(action: :user_privileges)
  end
end

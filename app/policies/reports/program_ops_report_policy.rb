class Reports::ProgramOpsReportPolicy < BasePolicy
  def back_of_badge?
    allowed?(action: :back_of_badge)
  end

  def sign_up_sessions?
    allowed?(action: :sign_up_sessions)
  end
end

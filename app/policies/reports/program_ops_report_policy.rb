class Reports::ProgramOpsReportPolicy < BasePolicy
  def back_of_badge?
    allowed?(action: :back_of_badge)
  end
end

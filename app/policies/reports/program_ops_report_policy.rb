class Reports::ProgramOpsReportPolicy < BasePolicy
  def back_of_badge?
    allowed?(action: :back_of_badge)
  end

  def table_tents?
    allowed?(action: :table_tents)
  end
end

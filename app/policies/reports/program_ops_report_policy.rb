class Reports::ProgramOpsReportPolicy < BasePolicy
  def back_of_badge?
    allowed?(action: :back_of_badge)
  end

  def room_signs?
    allowed?(action: :room_signs)
  end
end

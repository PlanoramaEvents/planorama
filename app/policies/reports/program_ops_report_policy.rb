class Reports::ProgramOpsReportPolicy < BasePolicy
  def back_of_badge?
    allowed?(action: :back_of_badge)
  end

  def virtual_people?
    allowed?(action: :virtual_people)
  end
end

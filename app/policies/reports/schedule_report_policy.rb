class Reports::ScheduleReportPolicy < BasePolicy
  def schedule_diff?
    allowed?(action: :schedule_diff)
  end
end

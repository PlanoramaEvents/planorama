class Reports::SessionReportPolicy < BasePolicy
  def panels_with_too_few_people?
    allowed?(action: :panels_with_too_few_people)
  end

  def panels_with_too_many_people?
    allowed?(action: :panels_with_too_many_people)
  end
end

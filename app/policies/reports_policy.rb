class ReportsPolicy < ApplicationPolicy
  # TODO: test staff role, better still move to the Sec Service
  def is_admin_or_staff
    @person.convention_roles.inject(false) { |res, grp| res || grp.admin? || grp.staff?}
  end

  def participant_selections?
    is_admin_or_staff
  end

  def session_selections?
    is_admin_or_staff
  end
end

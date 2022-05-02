class PlannerPolicy < ApplicationPolicy
  # TODO: test staff role, better still move to the Sec Service
  def is_admin
    @person.convention_roles.inject(false) { |res, grp| res || grp.admin?}
  end

  def is_admin_or_staff
    @person.convention_roles.inject(false) { |res, grp| res || grp.admin? || grp.staff?}
  end

  def update?
    is_admin_or_staff
  end

  def create?
    is_admin_or_staff
  end

  def index?
    is_admin_or_staff
  end

  def show?
    is_admin_or_staff
  end

  def destroy?
    is_admin_or_staff
  end

  class Scope < PlannerPolicy::Scope
    def is_admin_or_staff
      @person.convention_roles.inject(false) { |res, grp| res || grp.admin? || grp.staff?}
    end

    def resolve
      if is_admin_or_staff
        scope.all
      else
        if scope == Person
          scope.where(id: @person.id)
        elsif scope.attribute_method? :peron_id
          scope.where(person_id: @person.id)
        else
          # return no records
          scope.where(id: nil)
        end
      end
    end
  end
end

#
# def permitted_attributes_for_create
# etc to permit attribute for create and update based on role ?
#
# TODO: also need to adjust serializer for attributes that are not
# allowed to be read
# ApplicationRecord.descendants.collect(&:name)
#
# Person.attribute_names
# Person.type_for_attribute('acceptance_status')
# 'acceptance_status'.pluralize
# Person.send 'acceptance_status'.pluralize to get the mapping
#
# Sensitive Information - need to be able to use this in sderializer as well
# Class attribute name scope?
#
#
# ABAC - model, attribute, action, role(s)
#

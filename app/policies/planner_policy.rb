class PlannerPolicy < ApplicationPolicy
  def update?
    @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
  end

  def create?
    @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
  end

  def index?
    @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
  end

  def show?
    @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
  end

  def destroy?
    @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
  end

  class Scope < Scope
    def resolve
      if @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
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

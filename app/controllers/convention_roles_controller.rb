class ConventionRolesController < ResourceController
  MODEL_CLASS = 'ConventionRole'.freeze
  SERIALIZER_CLASS = 'ConventionRoleSerializer'.freeze

  def belongs_to_param_id
    params[:person_id]
  end

  def belong_to_class
    Person
  end

  def belongs_to_relationship
    'convention_roles'
  end
end

class PersonRolesController < ResourceController
  MODEL_CLASS = 'PersonRole'.freeze
  SERIALIZER_CLASS = 'PersonRoleSerializer'.freeze

  def belongs_to_param_id
    params[:person_id]
  end

  def belong_to_class
    Person
  end

  def belongs_to_relationship
    'person_roles'
  end
end

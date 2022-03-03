class PersonGroupsController < ResourceController
  MODEL_CLASS = 'PersonGroup'.freeze
  SERIALIZER_CLASS = 'PersonGroupSerializer'.freeze

  def belongs_to_param_id
    params[:person_id]
  end

  def belong_to_class
    Person
  end

  def belongs_to_relationship
    'person_groups'
  end
end

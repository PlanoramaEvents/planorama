class ParameterNameSerializer
  include JSONAPI::Serializer

  # set id?

  attributes :parameter_name, :parameter_description, :configuration
end

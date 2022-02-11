class ParameterNameSerializer
  include JSONAPI::Serializer

  attributes :parameter_name, :parameter_description, :parameter_type

  has_one :configuration, serializer: ConfigurationSerializer
end

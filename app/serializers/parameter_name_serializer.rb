# == Schema Information
#
# Table name: parameter_names
#
#  parameter_description :string(170)      not null
#  parameter_name        :string(45)       not null, primary key
#  parameter_type        :string           default("String")
#
class ParameterNameSerializer
  include JSONAPI::Serializer

  attributes :parameter_name, :parameter_description, :parameter_type

  has_one :configuration, serializer: ConfigurationSerializer
end

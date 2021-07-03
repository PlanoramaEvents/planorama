class ConfigurationSerializer < ActiveModel::Serializer
  attributes :id, :parameter, :parameter_value,
             :created_at, :updated_at
end

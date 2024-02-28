# == Schema Information
#
# Table name: configurations
#
#  id              :uuid             not null, primary key
#  lock_version    :integer          default(0)
#  parameter       :string(45)       not null
#  parameter_json  :jsonb
#  parameter_value :string(150)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  fk_configurations_parameters_idx  (parameter)
#  fl_configurations_unique_index    (parameter) UNIQUE
#
# Foreign Keys
#
#  fk_configurations_parameters  (parameter => parameter_names.parameter_name)
#
class ConfigurationSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version,
             :parameter, :parameter_value,
             :created_at, :updated_at
end

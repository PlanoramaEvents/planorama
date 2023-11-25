# == Schema Information
#
# Table name: parameter_names
#
#  parameter_description :string(170)      not null
#  parameter_name        :string(45)       not null, primary key
#  parameter_type        :string           default("String")
#
class ParameterName < ApplicationRecord
  self.primary_key = 'parameter_name'

  has_one :configuration, foreign_key: 'parameter', dependent: :destroy
end

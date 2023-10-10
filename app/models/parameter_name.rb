class ParameterName < ApplicationRecord
  self.primary_key = 'parameter_name'

  has_one :configuration, foreign_key: 'parameter', dependent: :destroy
end

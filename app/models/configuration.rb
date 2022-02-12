class Configuration < ApplicationRecord
  belongs_to :parameter_name, foreign_key: 'parameter', inverse_of: :configuration
end

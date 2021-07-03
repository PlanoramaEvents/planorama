class Configuration < ApplicationRecord
  belongs_to :parameter_name, foreign_key: 'parameter'
end

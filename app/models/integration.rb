class Integration < ApplicationRecord
  scope :login, ->  { where("config @> ?", '{"type": "login", "enabled": true}')}
end

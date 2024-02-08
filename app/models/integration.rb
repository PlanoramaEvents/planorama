# == Schema Information
#
# Table name: integrations
#
#  id           :uuid             not null, primary key
#  config       :jsonb            not null
#  lock_version :integer          default(0)
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Integration < ApplicationRecord
  scope :login, ->  { where("config @> ?", '{"type": "login", "enabled": true}')}
end

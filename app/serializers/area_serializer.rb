# == Schema Information
#
# Table name: areas
#
#  id           :uuid             not null, primary key
#  lock_version :integer          default(0)
#  name         :string
#  sort_order   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_areas_on_name  (name) UNIQUE
#
class AreaSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :created_at, :updated_at,
             :name, :sort_order
end

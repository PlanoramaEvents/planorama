# == Schema Information
#
# Table name: room_sets
#
#  id           :uuid             not null, primary key
#  description  :string
#  lock_version :integer          default(0)
#  name         :string
#  sort_order   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class RoomSetSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :created_at, :updated_at,
             :name, :sort_order, :description
end

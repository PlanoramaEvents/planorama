# == Schema Information
#
# Table name: formats
#
#  id           :uuid             not null, primary key
#  lock_version :integer          default(0)
#  name         :string           not null
#  position     :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class FormatSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :created_at, :updated_at,
             :name, :position
end

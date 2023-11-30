# == Schema Information
#
# Table name: tag_contexts
#
#  id           :uuid             not null, primary key
#  lock_version :integer          default(0)
#  name         :string
#  publish      :boolean          default(TRUE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class TagContextSerializer
  include JSONAPI::Serializer

  attributes :id, :name
end

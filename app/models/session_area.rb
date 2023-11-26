# == Schema Information
#
# Table name: session_areas
#
#  id           :uuid             not null, primary key
#  lock_version :integer
#  primary      :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  area_id      :uuid
#  session_id   :uuid
#
# Indexes
#
#  index_session_areas_on_session_id_and_area_id  (session_id,area_id) UNIQUE
#
class SessionArea < ApplicationRecord
  belongs_to  :area
  belongs_to  :session

  validates_presence_of :area
  validates_presence_of :session

  accepts_nested_attributes_for :area

  # We do not really need to audo this
  # has_paper_trail versions: { class_name: 'Audit::SessionVersion' }, ignore: [:updated_at, :created_at, :lock_version]
end

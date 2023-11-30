# == Schema Information
#
# Table name: venues
#
#  id           :uuid             not null, primary key
#  address      :string
#  lock_version :integer          default(0)
#  name         :string
#  sort_order   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Venue < ApplicationRecord
  include RankedModel
  ranks :sort_order

  has_many :rooms, dependent: :destroy
  validates_presence_of :name

end

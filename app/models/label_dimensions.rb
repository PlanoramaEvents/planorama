# == Schema Information
#
# Table name: label_dimensions
#
#  id                 :uuid             not null, primary key
#  across             :integer
#  bottom_margin      :float
#  down               :integer
#  horizontal_spacing :float
#  label_height       :float
#  label_width        :float
#  left_margin        :float
#  manufacturer       :string
#  name               :string
#  orientation        :string
#  page_size          :string
#  right_margin       :float
#  top_margin         :float
#  unit               :string
#  vertical_spacing   :float
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class LabelDimensions < ApplicationRecord
end

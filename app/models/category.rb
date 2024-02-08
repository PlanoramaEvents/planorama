# == Schema Information
#
# Table name: categories
#
#  id           :uuid             not null, primary key
#  active       :boolean          default(TRUE), not null
#  description  :string
#  name         :string(191)      not null
#  reserved     :boolean          default(FALSE), not null
#  target_class :string(100)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  by_active_status          (active)
#  by_name_and_target_class  (name,target_class) UNIQUE
#  by_reserved_status        (reserved)
#
class Category < ApplicationRecord
  belongs_to :category_name
  belongs_to :categorized, polymorphic: true
end

class CategoryName < ApplicationRecord
  has_many :categories, dependent: :destroy
end

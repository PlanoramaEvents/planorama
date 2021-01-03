class Category < ApplicationRecord
  belongs_to :category_name
  belongs_to :categorized, polymorphic: true
end

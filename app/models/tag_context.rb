class TagContext < ApplicationRecord
  has_many :taggings,
           foreign_key: 'context',
           primary_key: :name,
           class_name: 'ActsAsTaggableOn::Tagging'
  has_many :tags, through: :taggings
end

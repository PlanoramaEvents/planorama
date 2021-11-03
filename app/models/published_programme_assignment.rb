class PublishedProgrammeAssignment < ApplicationRecord
  self.primary_key = :programme_item_assignment_id

  include RankedModel
  ranks :sort_order, with_same: [:programme_item_id]
  belongs_to  :person
  belongs_to  :published_programme_item,
              foreign_key: 'programme_item_id'
  belongs_to  :programme_assignment

  has_one :programme_assignment_role_type

  enum visibility: {
    is_public: 'public',
    is_private: 'private'
  }
end

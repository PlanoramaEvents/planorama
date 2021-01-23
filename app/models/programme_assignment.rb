class ProgrammeAssignment < ApplicationRecord
  include RankedModel
  ranks :sort_order, with_same: [:programme_item_id]

  belongs_to  :person
  belongs_to  :programme_item
  has_one     :published_programme_assignment

  has_one :programme_assignment_role_type

  # enum visibility: {
  #   public: 'public',
  #   private: 'private'
  # }
end

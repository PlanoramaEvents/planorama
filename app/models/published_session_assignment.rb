class PublishedSessionAssignment < ApplicationRecord
  self.primary_key = :session_assignment_id

  include RankedModel
  ranks :sort_order, with_same: [:session_id]
  belongs_to  :person
  belongs_to  :published_session,
              foreign_key: 'session_id'
  belongs_to  :session_assignment

  has_one :session_assignment_role_type

  enum visibility: {
    is_public: 'public',
    is_private: 'private'
  }
end

class PublishedSessionAssignment < ApplicationRecord
  self.primary_key = :session_assignment_id

  has_paper_trail versions: { class_name: 'Audit::PublishedSessionVersion' },
                  ignore: [:updated_at, :created_at, :lock_version, :sort_order],
                  limit: nil

  include RankedModel
  ranks :sort_order, with_same: [:published_session_id]

  belongs_to  :person
  belongs_to  :published_session
  belongs_to  :session_assignment_role_type, required: false
  belongs_to  :session_assignment

  alias :session :published_session

  enum visibility: {
    is_public: 'public',
    is_private: 'private'
  }
end

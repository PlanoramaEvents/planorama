class SessionAssignmentRoleType < ApplicationRecord
  self.table_name = "session_assignment_role_type"
  include RankedModel
  ranks :sort_order

  has_many :session_assignments
  has_many :published_session_assignments

  enum role_type: {
    participant: 'participant',
    staff: 'staff'
  }

  enum default_visibility: {
    is_public: 'public',
    is_private: 'private'
  }
end

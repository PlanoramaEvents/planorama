# == Schema Information
#
# Table name: session_assignment_role_type
#
#  id                 :uuid             not null, primary key
#  default_visibility :enum             default("is_public")
#  lock_version       :integer          default(0)
#  name               :string(100)      not null
#  role_type          :enum
#  sort_order         :integer
#  created_at         :datetime
#  updated_at         :datetime
#
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

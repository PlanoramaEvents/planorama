class ProgrammeAssignmentRoleType < ApplicationRecord
  has_many :programme_item_assignments
  has_many :published_programme_item_assignments

  enum role_type: {
    participant: 'PARTICIPANT',
    staff: 'STAFF'
  }

  enum default_visibility: {
    public: 'PUBLIC',
    private: 'PRIVATE'
  }
end

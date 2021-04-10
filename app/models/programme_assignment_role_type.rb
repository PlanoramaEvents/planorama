## schema
# CREATE TABLE public.programme_assignment_role_type (
#     id integer NOT NULL,
#     lock_version integer DEFAULT 0,
#     created_at timestamp without time zone,
#     updated_at timestamp without time zone,
#     name character varying(100) NOT NULL,
#     role_type public.assignment_role_enum,
#     default_visibility public.visibility_enum DEFAULT 'public'::public.visibility_enum
# );
class ProgrammeAssignmentRoleType < ApplicationRecord
  self.table_name = "programme_assignment_role_type"
  has_many :programme_assignments
  has_many :published_programme_assignments

  enum role_type: {
    participant: 'participant',
    staff: 'staff'
  }

  enum default_visibility: {
    is_public: 'public',
    is_private: 'private'
  }
end

## schema
# CREATE TABLE public.session_assignments (
#     id integer NOT NULL,
#     person_id integer NOT NULL,
#     created_at timestamp without time zone NOT NULL,
#     updated_at timestamp without time zone NOT NULL,
#     lock_version integer DEFAULT 0,
#     session_assignment_role_type_id integer NOT NULL,
#     session_id integer NOT NULL,
#     sort_order integer,
#     visibility public.visibility_enum DEFAULT 'public'::public.visibility_enum
# );
class SessionAssignment < ApplicationRecord
  include RankedModel
  ranks :sort_order, with_same: [:session_id]

  belongs_to  :person
  belongs_to  :session
  belongs_to  :session_assignment_role_type
  has_one     :published_session_assignment


  enum visibility: {
    is_public: 'public',
    is_private: 'private'
  }
end

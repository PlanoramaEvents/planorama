## schema
# CREATE TABLE public.programme_assignments (
#     id integer NOT NULL,
#     person_id integer NOT NULL,
#     created_at timestamp without time zone NOT NULL,
#     updated_at timestamp without time zone NOT NULL,
#     lock_version integer DEFAULT 0,
#     programme_assignment_role_type_id integer NOT NULL,
#     programme_item_id integer NOT NULL,
#     sort_order integer,
#     visibility public.visibility_enum DEFAULT 'public'::public.visibility_enum
# );
class ProgrammeAssignment < ApplicationRecord
  include RankedModel
  ranks :sort_order, with_same: [:programme_item_id]

  belongs_to  :person
  belongs_to  :programme_item
  belongs_to  :programme_assignment_role_type
  has_one     :published_programme_assignment


  enum visibility: {
    is_public: 'public',
    is_private: 'private'
  }
end

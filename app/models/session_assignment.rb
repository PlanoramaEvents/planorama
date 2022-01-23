## schema
# CREATE TABLE public.session_assignments (
#     id uuid DEFAULT public.gen_random_uuid() NOT NULL,
#     person_id uuid NOT NULL,
#     created_at timestamp without time zone NOT NULL,
#     updated_at timestamp without time zone NOT NULL,
#     lock_version integer DEFAULT 0,
#     session_assignment_role_type_id uuid NOT NULL,
#     session_id uuid NOT NULL,
#     sort_order integer,
#     visibility public.visibility_enum DEFAULT 'public'::public.visibility_enum,
#     interested boolean DEFAULT false,
#     interest_ranking integer,
#     interest_notes text,
#     interest_role_type uuid,
#     state character varying,
#     planner_notes text
# );
class SessionAssignment < ApplicationRecord
  include RankedModel
  ranks :sort_order, with_same: [:session_id]

  belongs_to  :person
  belongs_to  :session
  belongs_to  :session_assignment_role_type
  has_one     :published_session_assignment

  # interested in mod, not interested in mod, no preference
  enum interest_role: {
    no_preference: 'no_preference',
    can_moderate: 'can_moderate',
    not_moderate: 'not_moderate'
  }

  enum visibility: {
    is_public: 'public',
    is_private: 'private'
  }

  # We use the state machine to manage the "workflow" for the assignment
  include AASM

  aasm column: :state, skip_validation_on_save: true do
    state :proposed, initial: true
    state :accepted
    state :rejected

    event :accept do
      after do
        visibility = SessionAssignment::visibilities[:is_public]
      end

      transitions from: [:proposed, :rejected], to: :accepted
    end

    event :reject do
      after do
        visibility = SessionAssignment::visibilities[:is_private]
      end

      transitions from: [:proposed, :accepred], to: :rejected
    end
  end
end

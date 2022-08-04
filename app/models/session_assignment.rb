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

  has_paper_trail versions: { class_name: 'Audit::SessionVersion' },
                  ignore: [:updated_at, :created_at, :lock_version, :sort_order, :interested, :interest_ranking, :interest_notes, :planner_notes, :interest_role],
                  limit: nil

  belongs_to  :person
  belongs_to  :session
  belongs_to  :session_assignment_role_type, required: false
  has_one     :published_session_assignment # TODO: cascade delete?
  has_one :room, through: :session
  has_many :areas, through: :session

  validate :check_unique

  before_save :check_person_state

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

  validates_inclusion_of :state, in: %w( proposed accepted rejected )

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

  private

  # Ensure that we are not assigning a declined ot rejected person
  def check_person_state
    return if self.interested == false

    p = Person.find self.person_id
    if p.con_state == Person.con_states[:declined] || p.con_state == Person.con_states[:rejected]
      raise "Person in state not allowed to be assigned" if person.con_state == Person.con_states[:declined]
    end
  end

  # Check to see if this is a duplicate
  # session_id, person_id and session_assignment_role_type
  def check_unique
    return unless new_record?

    existing = if session_assignment_role_type_id
                 SessionAssignment.where([
                    'person_id = ? AND session_id = ? AND session_assignment_role_type_id = ?',
                    person_id, session_id, session_assignment_role_type_id
                  ])
               else
                 SessionAssignment.where([
                    'person_id = ? AND session_id = ?',
                    person_id, session_id
                  ])
               end

    errors.add(:session_assignment, "the assignment is not unique") if existing.count > 0
  end

end

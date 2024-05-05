# == Schema Information
#
# Table name: session_assignments
#
#  id                              :uuid             not null, primary key
#  interest_notes                  :text
#  interest_ranking                :integer
#  interest_role                   :enum             default("no_preference")
#  interested                      :boolean          default(FALSE)
#  lock_version                    :integer          default(0)
#  planner_notes                   :text
#  sort_order                      :integer
#  state                           :string
#  visibility                      :enum             default("is_public")
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  person_id                       :uuid             not null
#  session_assignment_role_type_id :uuid
#  session_id                      :uuid             not null
#
# Indexes
#
#  index_session_assignments_on_interest_role                    (interest_role)
#  index_session_assignments_on_session_assignment_role_type_id  (session_assignment_role_type_id)
#  pia_person_index                                              (person_id)
#  pis_prog_item_id_index                                        (session_id)
#
class SessionAssignment < ApplicationRecord
  include Aggregates
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
    return unless self.session_assignment_role_type_id
    return if self.state == 'rejected'

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

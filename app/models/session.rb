# == Schema Information
#
# Table name: sessions
#
#  id                        :uuid             not null, primary key
#  audience_size             :integer
#  description               :text
#  duration                  :integer
#  environment               :enum             default("unknown")
#  instructions_for_interest :text
#  interest_opened_at        :datetime
#  interest_opened_by        :string
#  is_break                  :boolean          default(FALSE)
#  item_notes                :text
#  lock_version              :integer          default(0)
#  maximum_people            :integer
#  minimum_people            :integer
#  minors_participation      :jsonb
#  open_for_interest         :boolean          default(FALSE)
#  participant_notes         :text
#  proofed                   :boolean          default(FALSE), not null
#  pub_reference_number      :integer
#  publish                   :boolean          default(FALSE), not null
#  recorded                  :boolean          default(FALSE), not null
#  require_signup            :boolean          default(FALSE)
#  room_notes                :text
#  short_title               :string(30)
#  start_time                :datetime
#  status                    :enum             default("draft")
#  streamed                  :boolean          default(FALSE), not null
#  tech_notes                :text
#  title                     :string(256)
#  updated_by                :string
#  visibility                :enum             default("is_public")
#  waiting_list_size         :integer          default(0)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  age_restriction_id        :uuid
#  format_id                 :uuid
#  room_id                   :uuid
#  room_set_id               :uuid
#
# Indexes
#
#  index_sessions_on_description                (description) USING gin
#  index_sessions_on_instructions_for_interest  (instructions_for_interest) USING gin
#  index_sessions_on_interest_opened_by         (interest_opened_by) USING gin
#  index_sessions_on_item_notes                 (item_notes) USING gin
#  index_sessions_on_participant_notes          (participant_notes) USING gin
#  index_sessions_on_room_id                    (room_id)
#  index_sessions_on_room_notes                 (room_notes) USING gin
#  index_sessions_on_tech_notes                 (tech_notes) USING gin
#  index_sessions_on_title                      (title) USING gin
#  index_sessions_on_updated_by                 (updated_by) USING gin
#
class Session < ApplicationRecord
  include XmlFormattable
  include Aggregates
  include DirtyAssociations

  validates_presence_of :title
  validates_numericality_of :duration, allow_nil: true
  validates_numericality_of :minimum_people, allow_nil: true
  validates_numericality_of :maximum_people, allow_nil: true
  validates_numericality_of :audience_size, allow_nil: true

  validates_length_of :short_title, maximum: 30, allow_nil: true

  # NOTE: when we have a config for default duration change to use a lambda
  attribute :duration, default: 60

  has_paper_trail versions: { class_name: 'Audit::SessionVersion' },
                  ignore: [:updated_at, :created_at, :updated_by, :lock_version, :interest_opened_by, :interest_opened_at],
                  limit: nil

  belongs_to :format, required: false
  has_one :published_session, dependent: :destroy

  belongs_to :room, required: false
  belongs_to :age_restriction, required: false
  belongs_to :room_set, required: false

  before_save :keep_who_did_it, :keep_interest_trail, :schedule_consistency

  # Ensure that empty strings are stored as nulls
  nilify_blanks only: [
    :title,
    :description,
    :item_notes,
    :tech_notes,
    :participant_notes,
    :instructions_for_interest,
    :room_notes,
    :short_title
  ]

  has_many :session_conflicts,
    -> {
      where("session_conflicts.conflict_id not in (select conflict_id from ignored_conflicts)")
      .where("session_assignment_name is null or session_assignment_name in (?)", ['Moderator', 'Participant', 'Invisible'])
      .where("conflict_session_assignment_name is null or conflict_session_assignment_name in (?)", ['Moderator', 'Participant', 'Invisible'])
    },
    class_name: 'Conflicts::SessionConflict'

  # Get where this session is on the other side of the conflict relationship
  has_many :conflict_sessions,
    -> {
      where("session_conflicts.conflict_id not in (select conflict_id from ignored_conflicts)")
      .where("session_assignment_name is null or session_assignment_name in (?)", ['Moderator', 'Participant', 'Invisible'])
      .where("conflict_session_assignment_name is null or conflict_session_assignment_name in (?)", ['Moderator', 'Participant', 'Invisible'])
      .where("session_conflicts.conflict_type != 'room_conflict' OR (session_conflicts.conflict_type = 'room_conflict' AND session_conflicts.session_start_time != session_conflicts.conflict_session_start_time)")
      # .where("session_conflicts.conflict_type != 'person_schedule_conflict' and session_conflicts.conflict_type != 'person_back_to_back'")
    },
    foreign_key: :conflict_session_id, class_name: 'Conflicts::SessionConflict'

  has_many :ignored_session_conflicts,
    -> {
      where("session_conflicts.conflict_id in (select conflict_id from ignored_conflicts)")
    },
    class_name: 'Conflicts::SessionConflict'

  has_many :ignored_conflict_sessions,
    -> {
      where("session_conflicts.conflict_id in (select conflict_id from ignored_conflicts)")
    },
    foreign_key: :conflict_session_id, class_name: 'Conflicts::SessionConflict'

  has_and_belongs_to_many :room_services

  has_many :session_assignments, dependent: :destroy do
    def role(role)
      # get the people with the given role
      where(['session_assignment_role_type_id = ?', role.id])
        .order('session_assignments.sort_order asc')
    end

    def roles(role_ids)
      # get the people with the given roles
      where(['session_assignment_role_type_id in (?)', role_ids])
        .order('session_assignments.sort_order asc')
    end

    # Get all the assignments for the given person in this session
    def for_person(person_id)
      where(['person_id = ?', person_id])
    end

    def interests_for(person_id)
      where(['person_id = ? and interested = true', person_id])
    end
  end
  has_many :people, through: :session_assignments

  has_many :participant_assignments,
    -> {
      joins("JOIN session_assignment_role_type as sart ON sart.id = session_assignments.session_assignment_role_type_id")
      .joins("JOIN people on people.id = session_assignments.person_id")
      .where("session_assignments.session_assignment_role_type_id is not null AND session_assignments.state != 'rejected'")
      .where("session_assignments.session_assignment_role_type_id not in (select id from session_assignment_role_type where session_assignment_role_type.name = 'Reserve' OR session_assignment_role_type.name = 'Invisible')")
      .order("sart.sort_order, people.published_name asc")
    },
    class_name: 'SessionAssignment'
  # has_many :participants, through: :participant_assignments #, source: :person, class_name: 'Person'

  # TODO: Will also need a published versioon of the relationship
  has_many :session_areas, inverse_of: :session,
           after_add: :dirty_associations,
           after_remove: :dirty_associations
  has_many :areas, through: :session_areas,
           after_add: :dirty_associations,
           after_remove: :dirty_associations
  accepts_nested_attributes_for :session_areas, allow_destroy: true
  # accepts_nested_attributes_for :areas, allow_destroy: true

  has_and_belongs_to_many :exclusions

  enum visibility: {
    is_public: 'public',
    is_private: 'private'
  }

  enum status: {
    draft: 'draft',
    reviewed: 'reviewed',
    revised: 'revised',
    dropped: 'dropped'
  }

  enum environment: {
    unknown: 'unknown',
    in_person: 'in_person',
    hybrid: 'hybrid',
    virtual: 'virtual'
  }

  # acts_as_taggable
  acts_as_taggable_on :tags # for public consumption
  acts_as_taggable_on :labels # for admin use

  # TODO: need to add required setup (allowed to be null)

  def published?
    # No need to load the whole record ...
    PublishedSession.exists?(session_id: self.id)
  end

  def keep_who_did_it
    self.updated_by = PaperTrail.request.whodunnit if self.changed?
  end

  def keep_interest_trail
    if self.open_for_interest_changed?
      if self.open_for_interest
        self.interest_opened_by = PaperTrail.request.whodunnit
        self.interest_opened_at = Time.now
      end
    end
  end

  def self.conflict_counts
    conflicts = Conflicts::SessionConflict.arel_table
    ignored_conflicts = ::IgnoredConflict.arel_table

    conflicts.project(
      conflicts[:session_id].as('session_id'),
      conflicts[:session_id].count.as('conflict_count')
    )
    .where(
      conflicts[:conflict_type].not_eq('room_conflict')
        .or(
          conflicts[:conflict_type].eq('room_conflict')
          .and(
            conflicts[:session_start_time].not_eq(conflicts[:conflict_session_start_time])
          )
      )
      .and(
        conflicts[:session_assignment_name].eq(nil).or(conflicts[:session_assignment_name].in(['Moderator', 'Participant', 'Invisible'])).and(
          conflicts[:conflict_session_assignment_name].eq(nil).or(conflicts[:conflict_session_assignment_name].in(['Moderator', 'Participant', 'Invisible']))
        ).and(
          conflicts[:conflict_id].not_in(
            ignored_conflicts.project(ignored_conflicts[:conflict_id])
          )
        )
      )
    )
    .group('session_conflicts.session_id')
  end

  def schedule_consistency
    # if status dropped then we should not be scheduled in a space and time
    if status == Session.statuses[:dropped]
      self.room_id = nil
      self.start_time = nil
    end
  end
end

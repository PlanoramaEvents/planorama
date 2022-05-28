class Session < ApplicationRecord
  validates_presence_of :title
  validates_numericality_of :duration, allow_nil: true
  validates_numericality_of :minimum_people, allow_nil: true
  validates_numericality_of :maximum_people, allow_nil: true

  has_paper_trail versions: { class_name: 'Audit::SessionVersion' }, ignore: [:updated_at, :created_at]

  belongs_to :format, required: false
  has_one :published_session, dependent: :destroy

  belongs_to :room, required: false

  before_save :keep_who_did_it, :keep_interest_trail

  has_many :availability_conflicts, class_name: 'Conflicts::AvailabilityConflict'

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

  # TODO: Will also need a published versioon of the relationship
  has_many :session_areas, inverse_of: :session
  has_many :areas, through: :session_areas
  accepts_nested_attributes_for :session_areas, allow_destroy: true
  # accepts_nested_attributes_for :areas, allow_destroy: true

  enum visibility: {
    is_public: 'public',
    is_private: 'private'
  }

  # acts_as_taggable
  acts_as_taggable_on :tags

  # TODO: need to add required setup (allowed to be null)

  def published?
    !published_session.nil?
  end

  def keep_who_did_it
    self.updated_by = PaperTrail.request.whodunnit
  end

  def keep_interest_trail
    if self.open_for_interest_changed?
      if self.open_for_interest
        self.interest_opened_by = PaperTrail.request.whodunnit
        self.interest_opened_at = Time.now
      end
    end
  end

  # Aggregate for area queries
  # '1946 Project' = ANY(area_list) (contains this)
  # '1946 Project' != ANY(area_list) (does not contain this)
  # AND array_length(area_list, 1) > 1
  def self.area_list
    sessions = Session.arel_table
    session_areas = Arel::Table.new(SessionArea.table_name) #.alias('session')
    areas = Arel::Table.new(Area.table_name)

    sessions.project(sessions[:id].as('session_id'), area_aggregate_fn( areas[:name] ).as('area_list'))
      .join(session_areas, Arel::Nodes::OuterJoin).on(sessions[:id].eq(session_areas[:session_id]))
      .join(areas, Arel::Nodes::OuterJoin).on(session_areas[:area_id].eq(areas[:id]))
      .group('sessions.id')
  end

  def self.area_aggregate_fn(col)
    Arel::Nodes::NamedFunction.new('array_remove',[Arel::Nodes::NamedFunction.new('array_agg',[col]), Arel::Nodes::SqlLiteral.new("NULL")])
  end

# NOTE: This only matches  that have the exact set of specified tags. If a user has additional tags, they are not returned.
# Session.tagged_with(["awesome", "cool"], :match_all => true)
#
# # Find  with any of the specified tags:
# Session.tagged_with(["awesome", "cool"], :any => true)
#
# Get all the tags for sessions
# Session.tags_on(:tags).order(:name)
#
# class_name = params[:class]
# tags = Arel::Table.new(ActsAsTaggableOn::Tag.table_name)
# taggings = Arel::Table.new(ActsAsTaggableOn::Tagging.table_name)
# ActsAsTaggableOn::Tag.where(
#   tags[:id].in(
#     taggings.project(taggings[:tag_id]).where(
#       taggings[:taggable_type]
#       .eq(class_name)
#     ).distinct
#   )
# ).where(
#   tags[:name].matches("%#{query}%")
# )
  # TODO: revisit for exclusion mappings
  # has_many :excluded_items_survey_maps, dependent: :destroy
end

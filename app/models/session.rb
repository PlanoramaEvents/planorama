## schema
# CREATE TABLE public.sessions (
#     id integer NOT NULL,
#     duration integer,
#     minimum_people integer,
#     maximum_people integer,
#     item_notes text,
#     created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
#     updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
#     lock_version integer DEFAULT 0,
#     format_id integer,
#     pub_reference_number integer,
#     mobile_card_size integer DEFAULT 1 NOT NULL,
#     audience_size integer,
#     participant_notes text,
#     is_break boolean DEFAULT false,
#     description text,
#     title character varying(256),
#     start_time timestamp without time zone,
#     room_id integer,
#     visibility public.visibility_enum DEFAULT 'public'::public.visibility_enum,
#     publish boolean DEFAULT false NOT NULL
# );

class Session < ApplicationRecord
  validates_presence_of :title
  validates_numericality_of :duration, allow_nil: true
  validates_numericality_of :minimum_people, allow_nil: true
  validates_numericality_of :maximum_people, allow_nil: true

  has_paper_trail versions: { class_name: 'Audit::SessionVersion' }, ignore: [:updated_at, :created_at]

  belongs_to :format, required: false
  has_one :published_session, dependent: :destroy

  belongs_to :room, required: false

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

    def my_interest(person_id)
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

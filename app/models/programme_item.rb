## schema
# CREATE TABLE public.programme_items (
#     id integer NOT NULL,
#     duration integer,
#     minimum_people integer,
#     maximum_people integer,
#     item_notes text,
#     created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
#     updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
#     lock_version integer DEFAULT 0,
#     format_id integer,
#     setup_type_id integer,
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

class ProgrammeItem < ApplicationRecord
  validates_presence_of :title
  validates_numericality_of :duration, allow_nil: true
  validates_numericality_of :minimum_people, allow_nil: true
  validates_numericality_of :maximum_people, allow_nil: true

  belongs_to :setup_type
  belongs_to :format
  has_one :published_programme_item, dependent: :destroy

  has_many :programme_assignments, dependent: :destroy do
    def role(role)
      # get the people with the given role
      where(['programme_assignment_role_type_id = ?', role.id])
        .order('programme_assignments.sort_order asc')
    end

    def roles(role_ids)
      # get the people with the given roles
      where(['programme_assignment_role_type_id in (?)', role_ids])
        .order('programme_assignments.sort_order asc')
    end
  end
  has_many :people, through: :programme_assignments

  enum visibility: {
    is_public: 'public',
    is_private: 'private'
  }

  acts_as_taggable

  def published?
    !published_programme_item.nil?
  end

  # TODO: we want an idea that can be later promotted into an programme item
  # Need to know who create the idea, and when
  # We could use inheritance or some workflow (aasm)???

  # TODO: revisit for exclusion mappings
  # has_many :equipment_needs, dependent: :destroy
  # has_many :equipment_types, through: :equipment_needs
  # has_many :excluded_items_survey_maps, dependent: :destroy
  # has_many :mapped_survey_questions, :through => :excluded_items_survey_maps
end

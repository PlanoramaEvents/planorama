class ProgrammeItem < ApplicationRecord
  validates_presence_of :title
  validates_numericality_of :duration, allow_nil: true
  validates_numericality_of :minimum_people, allow_nil: true
  validates_numericality_of :maximum_people, allow_nil: true

  belongs_to :setup_type
  belongs_to :format
  has_one :published_programmme_item, dependent: :destroy

  has_many :programme_item_assignments, dependent: :destroy do
    def role(role)
      # get the people with the given role
      where(['programme_assignment_role_type_id = ?', role.id])
        .order('programme_item_assignments.sort_order asc')
    end

    def roles(role_ids)
      # get the people with the given roles
      where(['programme_assignment_role_type_id in (?)', role_ids])
        .order('programme_item_assignments.sort_order asc')
    end
  end
  has_many :people, through: :programme_item_assignments

  enum visibility: {
    public: 'public',
    private: 'private'
  }

  acts_as_taggable

  def published?
    !published_programmme_item.nil?
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

#
#
#
class PublishedSession < ApplicationRecord
  self.primary_key = :session_id

  has_paper_trail versions: { class_name: 'Audit::PublishedSessionVersion' },
                  ignore: [:updated_at, :created_at, :lock_version, :integrations],
                  limit: nil

  belongs_to :format, required: false
  belongs_to :session
  belongs_to :room, required: false

  belongs_to :age_restriction, required: false

  enum environment: {
    unknown: 'unknown',
    in_person: 'in_person',
    hybrid: 'hybrid',
    virtual: 'virtual'
  }

  has_many :published_session_assignments, dependent: :destroy do
    # get the people with the given role
    def role(role)
      where(['session_assignment_role_type_id = ?', role.id])
        .order('published_session_assignments.sort_order asc')
    end

    # get the people with the given roles
    def roles(role_ids)
      where(['session_assignment_role_type_id in (?)', role_ids])
        .order('published_session_assignments.sort_order asc')
    end
  end
  has_many :people, through: :published_session_assignments

  has_many :participant_assignments,
    -> {
      joins("JOIN session_assignment_role_type as sart ON sart.id = published_session_assignments.session_assignment_role_type_id")
      .joins("JOIN people on people.id = published_session_assignments.person_id")
      .where("published_session_assignments.session_assignment_role_type_id not in (select id from session_assignment_role_type where session_assignment_role_type.name = 'Reserve' OR session_assignment_role_type.name = 'Invisible')")
      .order("sart.sort_order, people.published_name asc")
    },
    class_name: 'PublishedSessionAssignment'
  # has_many :participants, through: :participant_assignments, source: :person, class_name: 'Person'

  enum visibility: {
    is_public: 'public',
    is_private: 'private'
  }

  has_many :session_areas, inverse_of: :session, foreign_key: 'session_id'
  has_many :areas, through: :session_areas

  # acts_as_taggable
  acts_as_taggable_on :tags

  def self.only_public
    where(visibility: 'public')
  end

  def self.only_private
    where(visibility: 'private')
  end

  def public?
    visibility == 'public'
  end

  def private?
    visibility == 'public'
  end

  def self.area_list
    sessions = PublishedSession.arel_table
    session_areas = Arel::Table.new(SessionArea.table_name) #.alias('session')
    areas = Arel::Table.new(Area.table_name)

    sessions.project(sessions[:session_id].as('session_id'), area_aggregate_fn( areas[:name] ).as('area_list'))
      .join(session_areas, Arel::Nodes::OuterJoin).on(sessions[:session_id].eq(session_areas[:session_id]))
      .join(areas, Arel::Nodes::OuterJoin).on(session_areas[:area_id].eq(areas[:id]))
      .group('published_sessions.session_id')
  end

  def self.area_aggregate_fn(col)
    Arel::Nodes::NamedFunction.new('array_remove',[Arel::Nodes::NamedFunction.new('array_agg',[col]), Arel::Nodes::SqlLiteral.new("NULL")])
  end
end

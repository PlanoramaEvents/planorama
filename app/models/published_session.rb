# == Schema Information
#
# Table name: published_sessions
#
#  audience_size        :integer
#  description          :text
#  duration             :integer
#  environment          :enum             default("unknown")
#  integrations         :jsonb            not null
#  is_break             :boolean          default(FALSE)
#  lock_version         :integer          default(0)
#  minors_participation :jsonb
#  participant_notes    :text
#  pub_reference_number :integer
#  recorded             :boolean          default(FALSE), not null
#  require_signup       :boolean          default(FALSE)
#  short_title          :string(30)
#  start_time           :datetime
#  streamed             :boolean          default(FALSE), not null
#  title                :string
#  visibility           :enum             default("is_public")
#  waiting_list_size    :integer          default(0)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  format_id            :uuid
#  room_id              :uuid
#  session_id           :uuid             not null, primary key
#
# Indexes
#
#  index_published_sessions_on_format_id  (format_id)
#
class PublishedSession < ApplicationRecord
  self.primary_key = :session_id
  include Aggregates

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

  acts_as_taggable_on :tags
  acts_as_taggable_on :labels

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
end

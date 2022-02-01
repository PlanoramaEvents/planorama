#
#
#
class PublishedSession < ApplicationRecord
  self.primary_key = :session_id

  belongs_to :format
  belongs_to :session

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

  enum visibility: {
    is_public: 'public',
    is_private: 'private'
  }

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
end

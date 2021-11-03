#
#
#
class PublishedProgrammeItem < ApplicationRecord
  self.primary_key = :programme_item_id

  belongs_to :format
  belongs_to :programme_item

  has_many :published_programme_assignments, dependent: :destroy do
    # get the people with the given role
    def role(role)
      where(['programme_assignment_role_type_id = ?', role.id])
        .order('published_programme_assignments.sort_order asc')
    end

    # get the people with the given roles
    def roles(role_ids)
      where(['programme_assignment_role_type_id in (?)', role_ids])
        .order('published_programme_assignments.sort_order asc')
    end
  end
  has_many :people, through: :published_programme_assignments

  enum visibility: {
    is_public: 'public',
    is_private: 'private'
  }

  acts_as_taggable

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

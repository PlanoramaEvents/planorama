# == Schema Information
#
# Table name: published_session_assignments
#
#  integrations                    :jsonb            not null
#  lock_version                    :integer          default(0)
#  sort_order                      :integer
#  visibility                      :enum             default("is_public")
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  person_id                       :uuid             not null
#  published_session_id            :uuid             not null
#  session_assignment_id           :uuid             not null, primary key
#  session_assignment_role_type_id :uuid             not null
#
# Indexes
#
#  index_published_programme_item_assignments_on_person_id  (person_id)
#  pub_progitem_assignment_item_index                       (published_session_id)
#  pub_progitem_assignment_person_index                     (person_id)
#
class PublishedSessionAssignment < ApplicationRecord
  self.primary_key = :session_assignment_id

  has_paper_trail versions: { class_name: 'Audit::PublishedSessionVersion' },
                  ignore: [:updated_at, :created_at, :lock_version, :sort_order, :integrations],
                  limit: nil

  include RankedModel
  ranks :sort_order, with_same: [:published_session_id]

  belongs_to  :person
  belongs_to  :published_session
  belongs_to  :session_assignment_role_type, required: false
  belongs_to  :session_assignment

  alias :session :published_session
  alias_attribute :session_id, :published_session_id

  enum visibility: {
    is_public: 'public',
    is_private: 'private'
  }
end

# == Schema Information
#
# Table name: survey_queries
#
#  id           :uuid             not null, primary key
#  date_order   :boolean          default(FALSE)
#  lock_version :integer          default(0)
#  name         :string
#  operation    :string
#  shared       :boolean
#  show_country :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  survey_id    :uuid
#  user_id      :uuid
#
class Survey::Query < ApplicationRecord
  # queryPredicates
  has_many :survey_query_predicates, dependent: :destroy

  belongs_to :user
  belongs_to :survey
end

# == Schema Information
#
# Table name: survey_answers
#
#  id               :uuid             not null, primary key
#  answer           :text
#  default          :boolean          default(FALSE)
#  lock_version     :integer          default(0)
#  next_page_action :enum             default("next_page")
#  other            :boolean          default(FALSE)
#  sort_order       :integer
#  value            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  next_page_id     :uuid
#  question_id      :uuid
#
# Indexes
#
#  index_survey_answers_on_next_page_action  (next_page_action)
#
class Survey::AnswerSerializer
  include JSONAPI::Serializer

  attributes :id, :answer, :value, :default, :created_at,
             :updated_at, :lock_version, :question_id,
             :sort_order, :other,
             :next_page_action, :next_page_id

  # attribute :next_page_id do |object|
  #   # consisteny check
  #   # next_page is either null, -1 or a valid survey_page_id
  #   object.next_page_id
  # end
end

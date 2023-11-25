# == Schema Information
#
# Table name: survey_questions
#
#  id            :uuid             not null, primary key
#  branching     :boolean          default(FALSE)
#  deleted_at    :datetime
#  horizontal    :boolean          default(FALSE)
#  linked_field  :text
#  lock_version  :integer          default(0)
#  mandatory     :boolean          default(FALSE)
#  private       :boolean          default(FALSE)
#  question      :text
#  question_type :string           default("textfield")
#  randomize     :boolean          default(FALSE)
#  regex         :string
#  sort_order    :integer
#  text_size     :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  page_id       :uuid
#
# Indexes
#
#  index_survey_questions_on_page_id  (page_id)
#
# Foreign Keys
#
#  fk_rails_...  (page_id => survey_pages.id)
#
class Survey::QuestionSerializer
  include JSONAPI::Serializer

  attributes :id, :question, :question_type,
             :created_at, :updated_at, :lock_version, :mandatory,
             :text_size, :sort_order, :horizontal,
             :private, :regex, :page_id,
             :branching, :linked_field

  has_many :answers, serializer: Survey::AnswerSerializer,
            links: {
              self: -> (object, params) {
                "#{params[:domain]}/question/#{object.id}"
              },
              related: -> (object, params) {
                "#{params[:domain]}/question/#{object.id}/answers"
              }
            }

  # attribute :sort_order_position do |object|
  #   object.sort_order_rank
  # end

  # It probably makes more sense for answers to be nested in here rather
  # than a relationship.
  # @Gail - please check
  # attribute :answers do |question|
  #   question.answers
  # end
end

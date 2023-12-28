# == Schema Information
#
# Table name: survey_pages
#
#  id               :uuid             not null, primary key
#  next_page_action :enum             default("next_page")
#  sort_order       :integer
#  title            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  next_page_id     :uuid
#  survey_id        :uuid
#
# Indexes
#
#  index_survey_pages_on_next_page_action  (next_page_action)
#  index_survey_pages_on_survey_id         (survey_id)
#
# Foreign Keys
#
#  fk_rails_...  (survey_id => surveys.id)
#
class Survey::PageSerializer
  include JSONAPI::Serializer

  attributes :id, :title, :next_page_action,
             :sort_order, :created_at, :updated_at, :survey_id

  # Because the DB can not set -1 for a UUID we fake it for the front end
  attribute :next_page_id do |object|
    object.next_page_action == 'submit' ? -1 : object.next_page_id
  end

  has_many :questions, serializer: Survey::QuestionSerializer,
            links: {
              self: -> (object, params) {
                "#{params[:domain]}/page/#{object.id}"
              },
              related: -> (object, params) {
                "#{params[:domain]}/page/#{object.id}/questions"
              }
            }
end

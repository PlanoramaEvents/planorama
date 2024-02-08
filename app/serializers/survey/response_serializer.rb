# == Schema Information
#
# Table name: survey_responses
#
#  id               :uuid             not null, primary key
#  lock_version     :integer          default(0)
#  response         :jsonb
#  response_as_text :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  question_id      :uuid             not null
#  submission_id    :uuid             not null
#
# Indexes
#
#  index_survey_responses_on_submission_id  (submission_id)
#  survey_resp_question_idx                 (question_id)
#
# Foreign Keys
#
#  fk_rails_...  (submission_id => survey_submissions.id)
#
class Survey::ResponseSerializer
  include JSONAPI::Serializer
  include Plano::AccessHelper

  attributes :id, :lock_version, :submission_id,
             :question_id

  attribute :response, if: Proc.new { |record, params| self.can_access_response?(record,params[:current_person]) }


  belongs_to :submission,
    links: {
      self: -> (object, params) {
        "#{params[:domain]}/response/#{object.id}"
      },
      related: -> (object, params) {
        "#{params[:domain]}/submission/#{object.submission_id}"
      }
    }
end

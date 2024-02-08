# == Schema Information
#
# Table name: survey_submissions
#
#  id               :uuid             not null, primary key
#  lock_version     :integer          default(0)
#  name             :string
#  submission_state :enum             default("draft")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  person_id        :uuid             not null
#  survey_id        :uuid             not null
#
# Indexes
#
#  index_survey_submissions_on_person_id         (person_id)
#  index_survey_submissions_on_submission_state  (submission_state)
#  index_survey_submissions_on_survey_id         (survey_id)
#
# Foreign Keys
#
#  fk_rails_...  (person_id => people.id)
#  fk_rails_...  (survey_id => surveys.id)
#
class Survey::SubmissionSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :survey_id, :person_id, :submission_state,
             :created_at, :updated_at


  attribute :submitter do |object|
    object.person.name if object.person
  end

  has_many :responses,
            links: {
              self: -> (object, params) {
                "#{params[:domain]}/submission/#{object.id}"
              },
              related: -> (object, params) {
                "#{params[:domain]}/submission/#{object.id}/responses"
              }
            }
end

# == Schema Information
#
# Table name: surveys
#
#  id                        :uuid             not null, primary key
#  allow_submission_edits    :boolean          default(TRUE)
#  authenticate_msg          :text
#  branded                   :boolean          default(TRUE)
#  declined_msg              :text
#  description               :text
#  lock_version              :integer          default(0)
#  mandatory_star            :boolean          default(TRUE)
#  name                      :string
#  numbered_questions        :boolean          default(FALSE)
#  public                    :boolean
#  published_on              :datetime
#  submit_string             :string           default("Save")
#  thank_you                 :text
#  transition_accept_status  :enum
#  transition_decline_status :enum
#  unassigned                :boolean          default(FALSE)
#  unique_submission         :boolean          default(TRUE)
#  use_captcha               :boolean          default(FALSE)
#  welcome                   :text
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  created_by_id             :uuid
#  published_by_id           :uuid
#  updated_by_id             :uuid
#
class SurveySerializer
  include JSONAPI::Serializer

  attributes :id, :created_at, :updated_at, :lock_version,
             :name, :welcome, :thank_you, :submit_string,
             :use_captcha, :public,
             :transition_accept_status, :transition_decline_status,
             :declined_msg, :authenticate_msg, :unassigned,
             :published_on, :description,
             :mandatory_star,
             :numbered_questions,
             :branded,
             :allow_submission_edits,
             :unique_submission

  attribute :xxx do |object|
  end

  has_many :pages,
           serializer: Survey::PageSerializer,
           links: {
             self: -> (object, params) {
               "#{params[:domain]}/survey/#{object.id}"
             },
             related: -> (object, params) {
               "#{params[:domain]}/survey/#{object.id}/pages"
             }
           }

  has_many :submissions,
           # serializer: Survey::SubmissionSerializer,
           lazy_load_data: true,
           links: {
             self: -> (object, params) {
               "#{params[:domain]}/survey/#{object.id}"
             },
             related: -> (object, params) {
               "#{params[:domain]}/survey/#{object.id}/submissions"
             }
           }

  belongs_to :published_by, serializer: PersonSerializer,
              if: Proc.new { |record| record.published_by_id },
              links: {
                self: -> (object, params) {
                  "#{params[:domain]}/survey/#{object.id}"
                },
                related: -> (object, params) {
                  "#{params[:domain]}/person/#{object.published_by_id}"
                }
              }

  belongs_to :created_by, serializer: PersonSerializer,
              if: Proc.new { |record| record.created_by_id },
              links: {
                self: -> (object, params) {
                  "#{params[:domain]}/survey/#{object.id}"
                },
                related: -> (object, params) {
                  "#{params[:domain]}/person/#{object.created_by_id}"
                }
              }

  belongs_to :updated_by, serializer: PersonSerializer,
              if: Proc.new { |record| record.updated_by_id },
              links: {
                self: -> (object, params) {
                  "#{params[:domain]}/survey/#{object.id}"
                },
                related: -> (object, params) {
                  "#{params[:domain]}/person/#{object.updated_by_id}"
                }
              }

  attribute :nbr_submissions do |object|
    object.submissions.joins(:responses).distinct.size
  end
end

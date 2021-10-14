class SurveySerializer
  include JSONAPI::Serializer

  attributes :id, :created_at, :updated_at, :lock_version,
             :name, :welcome, :thank_you, :submit_string,
             :use_captcha, :public,
             :transition_accept_status, :transition_decline_status,
             :declined_msg, :authenticate_msg, :anonymous,
             :published_on, :description, :fuuid,
             :mandatory_star,
             :numbered_questions,
             :branded,
             :allow_submission_edits

  has_many :survey_pages,
           serializer: Survey::PageSerializer,
           links: {
             self: -> (object, params) {
               "#{params[:domain]}/surveys/#{object.id}"
             },
             related: -> (object, params) {
               "#{params[:domain]}/surveys/#{object.id}/pages"
             }
           }

  belongs_to :published_by, serializer: PersonSerializer,
              if: Proc.new { |record| record.published_by_id },
              links: {
                self: -> (object, params) {
                  "#{params[:domain]}/surveys/#{object.id}"
                },
                related: -> (object, params) {
                  "#{params[:domain]}/people/#{object.published_by_id}"
                }
              }

  belongs_to :created_by, serializer: PersonSerializer,
              if: Proc.new { |record| record.created_by_id },
              links: {
                self: -> (object, params) {
                  "#{params[:domain]}/surveys/#{object.id}"
                },
                related: -> (object, params) {
                  "#{params[:domain]}/people/#{object.created_by_id}"
                }
              }

  belongs_to :updated_by, serializer: PersonSerializer,
              if: Proc.new { |record| record.updated_by_id },
              links: {
                self: -> (object, params) {
                  "#{params[:domain]}/surveys/#{object.id}"
                },
                related: -> (object, params) {
                  "#{params[:domain]}/people/#{object.updated_by_id}"
                }
              }

  attribute :nbr_submissions do |object|
    object.survey_submissions.size
  end
end

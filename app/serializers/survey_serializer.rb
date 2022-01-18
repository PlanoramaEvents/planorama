class SurveySerializer
  include JSONAPI::Serializer

  attributes :id, :created_at, :updated_at, :lock_version,
             :name, :welcome, :thank_you, :submit_string,
             :use_captcha, :public,
             :transition_accept_status, :transition_decline_status,
             :declined_msg, :authenticate_msg, :anonymous,
             :published_on, :description,
             :mandatory_star,
             :numbered_questions,
             :branded,
             :allow_submission_edits

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
           serializer: Survey::SubmissionSerializer,
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
    object.submissions.size
  end
end

class Survey::PageSerializer
  include JSONAPI::Serializer

  attributes :id, :title, :next_page_id,
             :sort_order, :created_at, :updated_at, :survey_id, :fuuid

  has_many :survey_questions, serializer: Survey::QuestionSerializer,
            links: {
              self: -> (object, params) {
                "#{params[:domain]}/surveys/#{object.survey_id}/pages/#{object.id}"
              },
              related: -> (object, params) {
                "#{params[:domain]}/surveys/#{object.survey_id}/pages/#{object.id}/questions"
              }
            }
end

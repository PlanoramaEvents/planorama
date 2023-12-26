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

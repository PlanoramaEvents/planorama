class Survey::QuestionSerializer
  include JSONAPI::Serializer

  attributes :id, :question, :question_type,
             :created_at, :updated_at, :lock_version, :mandatory,
             :text_size, :sort_order, :horizontal,
             :private, :regex, :page_id, :fuuid,
             :branching

  # has_many :survey_answers, serializer: Survey::AnswerSerializer,
  #           links: {
  #             self: -> (object, params) {
  #               "#{params[:domain]}/survey/#{object.survey_id}/page/#{object.page_id}/question/#{object.id}"
  #             },
  #             related: -> (object, params) {
  #               "#{params[:domain]}/survey/#{object.survey_id}/page/#{object.page_id}/question/#{object.id}/answers"
  #             }
  #           }

  attribute :sort_order_position do |object|
    object.sort_order
  end

  # It probably makes more sense for answers to be nested in here rather
  # than a relationship.
  # @Gail - please check
  attribute :survey_answers do |question|
    question.survey_answers
  end
end

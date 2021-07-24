class Survey::QuestionSerializer < ActiveModel::Serializer
  attributes :id, :question, :question_type,
             :created_at, :updated_at, :lock_version, :mandatory,
             :text_size, :sort_order, :horizontal,
             :private, :regex, :survey_page_id, :fuuid

  has_many :survey_answers, serializer: Survey::AnswerSerializer

  attribute :sort_order_position do
    object.sort_order
  end
end

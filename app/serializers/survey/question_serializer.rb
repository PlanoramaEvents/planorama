class Survey::QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :question, :question_type,
             :created_at, :updated_at, :lock_version, :mandatory,
             :text_size, :sort_order, :horizontal,
             :private, :regex, :survey_page_id

  has_many :survey_answers, serializer: Survey::AnswerSerializer
end

class Survey::PageSerializer < ActiveModel::Serializer
  attributes :id, :title, :next_page_id,
             :sort_order, :created_at, :updated_at, :survey_id, :fuuid

  has_many :survey_questions, serializer: Survey::QuestionSerializer
end

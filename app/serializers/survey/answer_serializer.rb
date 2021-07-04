class Survey::AnswerSerializer < ActiveModel::Serializer
  attributes :id, :answer, :default, :created_at,
             :updated_at, :lock_version, :survey_question_id,
             :sort_order, :next_page_id, :fuuid
end

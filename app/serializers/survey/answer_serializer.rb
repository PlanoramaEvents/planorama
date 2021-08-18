class Survey::AnswerSerializer < ActiveModel::Serializer
  attributes :id, :answer, :default, :created_at,
             :updated_at, :lock_version, :survey_question_id,
             :sort_order, :fuuid, :other

  attribute :next_page_id do
    # consisteny check
    # next_page is either null, -1 or a valid survey_page_id
    object.next_page_id
  end
end

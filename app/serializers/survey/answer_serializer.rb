class Survey::AnswerSerializer < ActiveModel::Serializer
  attributes :id, :answer, :default, :created_at,
    :updated_at, :lock_version, :survey_question_id,
    :sort_order, :help, :answertype_id, :start_time,
    :start_day, :duration
end

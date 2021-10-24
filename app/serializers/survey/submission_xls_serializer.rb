#
# TODO: check how this is going to work
#
class Survey::SubmissionXlsSerializer < Survey::SubmissionSerializer
  include ActiveModel::XlsSerializerMethods

  def initialize(object, options = {})
    super(object, options)
    @model_id = options[:serializer][:model_id] if options[:serializer][:model_id]
  end

  has_many :survey_responses do
    object.survey_responses.collect { |v|
      {v.survey_question_id => v.response_as_text}
    }.reduce({}, :merge)
  end

  # dynamic fields for columns
  def response_columns
    res = []

    if @model_id
      survey = Survey.find @model_id
      questions = survey.survey_questions

      if questions
        questions.each do |question|
          # exclude the line and text only question types
          next if [:hr, :textonly].include? question.question_type

          res << {
            name: "survey_responses.#{question.id}",
            display_name: question.question,
            question_type: question.question_type
          }
        end
      end
    end

    res
  end
end

class Survey::SubmissionXlsSerializer < Survey::SubmissionSerializer
  include ActiveModel::XlsSerializerMethods

  def initialize(object, options = {})
    super(object, options)
    @model_id = options[:serializer][:model_id] if options[:serializer][:model_id]
  end

  has_many :survey_responses do
    object.survey_responses.group_by{|v| v.survey_question_id}.transform_values! { |v|
      v.first.response_as_text
    }
  end

  # dynamic fields for columns
  def response_columns
    res = []

    if @model_id
      survey = Survey.find @model_id
      questions = survey.survey_questions

      if questions
        questions.each do |question|
          res << {
            name: "survey_responses.#{question.id}",
            display_name: question.question
          }
        end
      end
    end

    res
  end
end

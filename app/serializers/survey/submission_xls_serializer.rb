#
# TODO: check how this is going to work
#
class Survey::SubmissionXlsSerializer < ActiveModel::Serializer #< Survey::SubmissionSerializer
  include ActiveModel::XlsSerializerMethods

  attributes :id, :created_at, :updated_at

  def initialize(object, options = {})
    super(object, options)
    @model_id = options[:serializer][:model_id] if options[:serializer][:model_id]
  end

  has_many :responses do
    object.responses.collect { |v|
      {v.question_id => v.response_as_text}
    }.reduce({}, :merge)
  end

  # dynamic fields for columns
  def response_columns
    res = []

    if @model_id
      survey = Survey.find @model_id
      questions = survey.questions

      if questions
        questions.each do |question|
          # exclude the line and text only question types
          next if [:hr, :textonly].include? question.question_type

          res << {
            name: "responses.#{question.id}",
            display_name: question.question,
            question_type: question.question_type
          }
        end
      end
    end

    res
  end
end

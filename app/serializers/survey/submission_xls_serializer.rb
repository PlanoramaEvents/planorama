#
#
class Survey::SubmissionXlsSerializer < ActiveModel::Serializer #< Survey::SubmissionSerializer
  include Plano::AccessHelper
  include ActiveModel::XlsSerializerMethods

  attributes :id, :created_at, :updated_at

  def initialize(object, options = {})
    super(object, options)
    @model_id = options[:serializer][:model_id] if options[:serializer][:model_id]
    @current_person = options[:serializer][:current_person] if options[:serializer][:current_person]
  end

  # if the question is sensitive then we may not want to show
  # also if it is linked and the linked attr is sensitive
  # this is handled by the can_access_response
  has_many :responses do |rec|
    object.responses.collect { |v|
      {v.question_id => Survey::SubmissionXlsSerializer.can_access_response?(v,rec.current_person) ? v.response_as_text : ''}
    }.reduce({}, :merge)
  end

  # dynamic fields for columns
  def response_columns
    return RequestStore.store["response_columns_store"] if RequestStore.store["response_columns_store"]

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

    RequestStore.store["response_columns_store"] = res

    res
  end

  def current_person
    @current_person
  end
end

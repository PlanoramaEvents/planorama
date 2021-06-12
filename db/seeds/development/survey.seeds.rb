Survey.delete_all
Survey::Question.delete_all
Survey::Answer.delete_all

10.times.each do |i|
  name = Faker::Books::CultureSeries.book
  survey = Survey.create(
    name: name,
    thank_you: Faker::Lorem.sentence,
    alias: name.gsub(/\s+/, '_'),
    submit_string: 'submit',
    header_image: Faker::LoremFlickr.image(size: "1000x100"),
    use_captcha: Faker::Boolean.boolean(true_ratio: 0.8),
    public: Faker::Boolean.boolean(true_ratio: 0.8),
    authenticate: Faker::Boolean.boolean(true_ratio: 0.8),
    transition_accept_status: [nil, :probable, :accepted].sample,
    transition_decline_status: [nil, :unknown, :probable, :declined].sample,
    welcome: Faker::Lorem.sentence,
    declined_msg: Faker::Lorem.sentence,
    authenticate_msg: Faker::Lorem.sentence,
    anonymous: Faker::Boolean.boolean(true_ratio: 0.8)
  )

  10.times.each do
    question_type= [:textfield, :textbox, :singlechoice, :multiplechoice, :selectionbox, :break].sample;
    case (question_type)
    when :textfield, :textbox, :singlechoice, :selectionbox
      answer_type = 'String'
    when :multiplechoice
      answer_type = 'Array'
    else
      answer_type = 'null'
    end

    survey_question = Survey::Question.create(
      title: Faker::Lorem.sentence,
      question: Faker::Lorem.question,
      question_type: question_type,
      text_size: Faker::Number.between(from: 11, to: 16),
      answer_type: answer_type,
      horizontal: Faker::Boolean.boolean,
      survey_id: survey.id
    )
    case
    when :singlechoice, :multiplechoice, :selectionbox
      Faker::Number.between(from: 3, to: 5).times.each do
        Survey::Answer.create(
          survey_question_id: survey_question.id,
          answer: Faker::Lorem.words().join(" ")
        )
      end
    end
  end
end

p "Created #{Survey.count} surveys."


#surveys


Survey::Submission.destroy_all
Survey.destroy_all
# Survey::Page.delete_all
# Survey::Question.delete_all
# Survey::Answer.delete_all

10.times.each do |i|
  name = Faker::Books::CultureSeries.book

  creator = Person.all.sample.id
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
    description: Faker::Lorem.paragraph,
    declined_msg: Faker::Lorem.sentence,
    authenticate_msg: Faker::Lorem.sentence,
    anonymous: Faker::Boolean.boolean(true_ratio: 0.8),
    created_by_id: creator,
    updated_by_id: creator
  )

  page_title = Faker::Books::CultureSeries.civ
  survey_page = Survey::Page.create(
    title: page_title,
    survey_id: survey.id
  )

  10.times.each do
    question_type= [:textfield, :textbox, :singlechoice, :multiplechoice, :hr, :dropdown, :email, :address, :socialmedia].sample;

    survey_question = Survey::Question.create(
      question: Faker::Lorem.question,
      question_type: question_type,
      text_size: Faker::Number.between(from: 11, to: 16),
      horizontal: Faker::Boolean.boolean,
      survey_page_id: survey_page.id
    )
    case
    when :singlechoice, :multiplechoice, :dropdown
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

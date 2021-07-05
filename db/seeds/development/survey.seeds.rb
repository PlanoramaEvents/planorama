#surveys


Survey::Submission.destroy_all
Survey.destroy_all
# Survey::Page.delete_all
# Survey::Question.delete_all
# Survey::Answer.delete_all

#----------------


 # name = Faker::Books::CultureSeries.book

creator = Person.all.sample.id
survey = Survey.create(
  name: "Anna's First Survey",
  thank_you: Faker::Lorem.sentence,
  #alias: name.gsub(/\s+/, '_'),
  submit_string: 'submit',
  header_image: Faker::LoremFlickr.image(size: "1000x100"),
  use_captcha: Faker::Boolean.boolean(true_ratio: 0.8),
  public: Faker::Boolean.boolean(true_ratio: 0.8),
  authenticate: Faker::Boolean.boolean(true_ratio: 0.8),
  transition_accept_status: nil,
  transition_decline_status: nil,
  welcome: Faker::Lorem.sentence,
  description: "For my first survey, i bet you are all wondering why i brought you here today.  Mawwige, mawwige is what brights us together today.  I am a very model of a modern major general.  Something something something vegetable and mineral.",
  declined_msg: Faker::Lorem.sentence,
  authenticate_msg: Faker::Lorem.sentence,
  anonymous: false,
  created_by_id: creator,
  updated_by_id: creator
)

#page_title = Faker::Books::CultureSeries.civ
survey_page = Survey::Page.create(
  title: "Page the very first",
  survey_id: survey.id
)
survey_page2 = Survey::Page.create(
  title: "Page the tottaly second",
  survey_id: survey.id
)

survey_page.update(next_page_id: survey_page2.id)


# question_type= [:textfield, :textbox, :singlechoice, :multiplechoice, :hr, :dropdown, :email, :address, :socialmedia].sample;


survey_question = Survey::Question.create(
  question: "What is your name?",
  question_type: :textfield,
  text_size: Faker::Number.between(from: 11, to: 16),
  horizontal: Faker::Boolean.boolean,
  survey_page_id: survey_page.id
)
survey_question2 = Survey::Question.create(
  question: "What is your quest?",
  question_type: :textfield,
  text_size: Faker::Number.between(from: 11, to: 16),
  horizontal: Faker::Boolean.boolean,
  survey_page_id: survey_page.id
)
survey_question3 = Survey::Question.create(
  question: "What is the air speed velocity of an unladen swallow?",
  question_type: :singlechoice,
  text_size: Faker::Number.between(from: 11, to: 16),
  horizontal: Faker::Boolean.boolean,
  survey_page_id: survey_page2.id
)
Survey::Answer.create(
  survey_question_id: survey_question3.id,
  answer: "African"
)
Survey::Answer.create(
  survey_question_id: survey_question3.id,
  answer: "European"
)
Survey::Answer.create(
  survey_question_id: survey_question3.id,
  answer: "I don't know"
)

p "Anna's survey created"

#----------------

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
  p "One more survey created"
end

p "Created #{Survey.count} surveys."

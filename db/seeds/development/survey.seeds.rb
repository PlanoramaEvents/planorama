#surveys
p "Start development survey seeds"


return if Survey.count > 0

after "development:person" do


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
    submit_string: 'submit',
    use_captcha: Faker::Boolean.boolean(true_ratio: 0.8),
    public: false,
    transition_accept_status: nil,
    transition_decline_status: nil,
    welcome: Faker::Lorem.sentence,
    description: "For my first survey, i bet you are all wondering why i brought you here today.  Mawwige, mawwige is what brights us together today.  I am a very model of a modern major general.  Something something something vegetable and mineral.",
    declined_msg: Faker::Lorem.sentence,
    authenticate_msg: Faker::Lorem.sentence,
    unassigned: false,
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
    page_id: survey_page.id
  )
  survey_question2 = Survey::Question.create(
    question: "What is your quest?",
    question_type: :textfield,
    text_size: Faker::Number.between(from: 11, to: 16),
    horizontal: Faker::Boolean.boolean,
    page_id: survey_page.id
  )
  survey_question3 = Survey::Question.create(
    question: "What is the air speed velocity of an unladen swallow?",
    question_type: :singlechoice,
    text_size: Faker::Number.between(from: 11, to: 16),
    horizontal: Faker::Boolean.boolean,
    page_id: survey_page2.id
  )
  Survey::Answer.create(
    question_id: survey_question3.id,
    answer: "African"
  )
  Survey::Answer.create(
    question_id: survey_question3.id,
    answer: "European"
  )
  Survey::Answer.create(
    question_id: survey_question3.id,
    answer: "I don't know"
  )

  p "Anna's survey created"

  creator = Person.all.sample.id
  survey = Survey.create(
    name: "Most Awesome Survey with a longer title because it is just that awesome okay?",
    thank_you: Faker::Lorem.sentence,
    submit_string: 'submit',
    use_captcha: Faker::Boolean.boolean(true_ratio: 0.8),
    public: false,
    transition_accept_status: nil,
    transition_decline_status: nil,
    welcome: Faker::Lorem.sentence,
    description: "I like bit butts and i can not lie.  Other brothers can deny, when a girl walks in with... it is so late at night and i cant even make more of this stuff up.  But this needs to be a few lines long for reasons so iam jsut typign anything that ends up in my head.  This may be dangerous.",
    declined_msg: Faker::Lorem.sentence,
    authenticate_msg: Faker::Lorem.sentence,
    unassigned: false,
    created_by_id: creator,
    updated_by_id: creator
  )

  #page_title = Faker::Books::CultureSeries.civ
  survey_page = Survey::Page.create(
    title: "This is going to be the title of my survey",
    survey_id: survey.id
  )
  survey_page2 = Survey::Page.create(
    title: "Another day another page title",
    survey_id: survey.id
  )

  survey_page.update(next_page_id: survey_page2.id)


  # question_type= [:textfield, :textbox, :singlechoice, :multiplechoice, :hr, :dropdown, :email, :address, :socialmedia].sample;


  survey_question = Survey::Question.create(
    question: "What should we know about you?",
    question_type: :textbox,
    text_size: Faker::Number.between(from: 11, to: 16),
    horizontal: Faker::Boolean.boolean,
    page_id: survey_page.id,
    sort_order: 0
  )
  survey_question2 = Survey::Question.create(
    question: "Are your pants on fire?",
    question_type: :textfield,
    text_size: Faker::Number.between(from: 11, to: 16),
    horizontal: Faker::Boolean.boolean,
    page_id: survey_page.id,
    sort_order: 1
  )
  survey_question3 = Survey::Question.create(
    question: "What is the meaning of life?",
    question_type: :multiplechoice,
    text_size: Faker::Number.between(from: 11, to: 16),
    horizontal: Faker::Boolean.boolean,
    page_id: survey_page2.id,
    sort_order: 2
  )
  Survey::Answer.create(
    question_id: survey_question3.id,
    answer: "42"
  )
  Survey::Answer.create(
    question_id: survey_question3.id,
    answer: "6x9"
  )
  Survey::Answer.create(
    question_id: survey_question3.id,
    answer: "Every sperm is sacred"
  )

  p "Anna's survey created again"
  #----------------

  10.times.each do |i|
    name = Faker::Books::CultureSeries.book

    creator = Person.all.sample.id
    survey = Survey.create(
      name: name,
      thank_you: Faker::Lorem.sentence,
      submit_string: 'submit',
      use_captcha: Faker::Boolean.boolean(true_ratio: 0.8),
      public: false,
      transition_accept_status: [nil, :probable, :accepted].sample,
      transition_decline_status: [nil, :not_set, :declined].sample,
      welcome: Faker::Lorem.sentence,
      description: Faker::Lorem.paragraph,
      declined_msg: Faker::Lorem.sentence,
      authenticate_msg: Faker::Lorem.sentence,
      unassigned: Faker::Boolean.boolean(true_ratio: 0.8),
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
        page_id: survey_page.id
      )
      case
      when :singlechoice, :multiplechoice, :dropdown
        Faker::Number.between(from: 3, to: 5).times.each do
          Survey::Answer.create(
            question_id: survey_question.id,
            answer: Faker::Lorem.words().join(" ")
          )
        end
      end
    end
    p "One more survey created"
  end

end


p "Created #{Survey.count} surveys."
p "End development survey seeds"

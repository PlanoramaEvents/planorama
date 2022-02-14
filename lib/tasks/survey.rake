desc "Utilities for surveys"

# Takes the json api for a survey and puts it in the db
namespace :survey do
  task :import, [:filename] => :environment do |t, args|
    # puts "IMPORTING #{args} #{args[:filename]}"
    json_str = File.read(args[:filename])
    survey_json = JSON.parse json_str

    type = survey_json['data']['type']
    puts "IMPORTING #{type}"

    Survey.transaction do
      # create the survey
      create_survey(survey_json['data']['attributes'])

      # now we need pages, questions, answers
      included_entities = survey_json['included']
      pages = included_entities.select{|x| x['type'] == 'page'}
      pages.each do |page|
        create_page(page['attributes'])
      end

      questions = included_entities.select{|x| x['type'] == 'question'}
      questions.each do |question|
        create_question(question['attributes'])
      end

      answers = included_entities.select{|x| x['type'] == 'answer'}
      answers.each do |answer|
        create_answer(answer['attributes'])
      end
    end
  end

  def create_survey(attrs)
    Survey.create!(
      id: attrs['id'],
      name: attrs['name'],
      welcome: attrs['welcome'],
      thank_you: attrs['thank_you'],
      submit_string: attrs['submit_string'],
      use_captcha: attrs['use_captcha'],
      public: attrs['public'],
      transition_accept_status: attrs['transition_accept_status'],
      transition_decline_status: attrs['transition_decline_status'],
      declined_msg: attrs['declined_msg'],
      authenticate_msg: attrs['authenticate_msg'],
      anonymous: attrs['anonymous'],
      description: attrs['description'],
      mandatory_star: attrs['mandatory_star'],
      numbered_questions: attrs['numbered_questions'],
      branded: attrs['branded'],
      allow_submission_edits: attrs['allow_submission_edits']
    )
  end

  def create_page(attrs)
    Survey::Page.create!(
      id: attrs['id'],
      title: attrs['title'],
      next_page_id: attrs['next_page_id'],
      next_page_action: attrs['next_page_action'],
      sort_order: attrs['sort_order'],
      survey_id: attrs['survey_id']
    )
  end

  def create_question(attrs)
    Survey::Question.create!(
      id: attrs['id'],
      question: attrs['question'],
      question_type: attrs['question_type'],
      mandatory: attrs['mandatory'],
      text_size: attrs['text_size'],
      sort_order: attrs['sort_order'],
      horizontal: attrs['horizontal'],
      private: attrs['private'],
      regex: attrs['regex'],
      page_id: attrs['page_id'],
      branching: attrs['branching']
    )
  end

  def create_answer(attrs)
    Survey::Answer.create!(
      id: attrs['id'],
      answer: attrs['answer'],
      default: attrs['default'],
      question_id: attrs['question_id'],
      sort_order: attrs['sort_order'],
      other: attrs['other'],
      next_page_action: attrs['next_page_action'],
      next_page_id: attrs['next_page_id']
    )
  end
end

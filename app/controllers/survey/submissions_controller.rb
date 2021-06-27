class Survey::SubmissionsController < ResourceController
  SERIALIZER_CLASS = 'Survey::SubmissionSerializer'.freeze
  MODEL_CLASS = 'Survey::Submission'.freeze
  POLICY_CLASS = 'SubmissionsPolicy'.freeze

  def belong_to_class
    Survey
  end

  def belongs_to_relationship
    'survey_submissions'
  end

  def before_save
    # Make sure the submission is assigned to the current person
    @object.person_id = current_person.id
  end

  def includes
    [
      :survey_responses
    ]
  end


  def allowed_params
    %i[
      lock_version
      person_id
      survey_id
      survey_responses
    ] << [
      survey_responses_attributes: %i[
        id
        lock_version
        _destroy
        survey_submission_id
        survey_question_id
        response
      ]
    ]
  end
end

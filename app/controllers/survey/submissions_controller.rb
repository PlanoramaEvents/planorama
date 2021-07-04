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

  def belongs_to_param_id
    params[:survey_id]
  end

  def before_save
    # Make sure the submission is assigned to the current person
    # if there is one ... and survey is not anonymous
    @object.person_id = current_person.id if current_person
  end

  def serializer_includes
    [
      :survey_responses
    ]
  end

  def includes
    serializer_includes
  end



  def allowed_params
    %i[
      person_id
      survey_id
      survey_responses
      fuuid
    ] << [
      survey_responses_attributes: %i[
        id
        lock_version
        _destroy
        survey_submission_id
        survey_question_id
        fuuid
      ] << [
        response: %i[
          text
          fuuid
        ] << [
          answers: [],
          address: %i[
            street
            street2
            city
            state
            zip
            country
            fuuid
          ],
          socialmedia: %i[
            twitter
            facebook
            linkedin
            twitch
            youtube
            instagram
            flickr
            reddit
            fuuid
          ]
        ]
      ]
    ]
  end
end

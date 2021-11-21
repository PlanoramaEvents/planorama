class Survey::SubmissionsController < ResourceController
  SERIALIZER_CLASS = 'Survey::SubmissionSerializer'.freeze
  MODEL_CLASS = 'Survey::Submission'.freeze
  POLICY_CLASS = 'Survey::SubmissionsPolicy'.freeze
  XLS_SERIALIZER_CLASS = 'Survey::SubmissionXlsSerializer'.freeze
  DEFAULT_ORDER = 'updated_at'

  def belong_to_class
    Survey if params[:survey_id].present?
    Person if params[:person_id].present?
  end

  def belongs_to_relationship
    'submissions'
  end

  def belongs_to_param_id
    params[:survey_id] || params[:person_id]
  end

  def before_save
    # Make sure the submission is assigned to the current person
    # if there is one ... and survey is not anonymous
    @object.person_id = current_person.id if current_person
  end

  def serializer_includes
    [
      :responses
    ]
  end

  def includes
    serializer_includes
  end

  def delete_all
    Survey.transaction do
      survey = Survey.find_by(id: params[:survey_id])
      authorize survey, policy_class: policy_class

      survey.submissions.destroy_all

      render status: :ok, json: {}.to_json, content_type: 'application/json'
    end
  end

  def allowed_params
    %i[
      id
      person_id
      survey_id
      responses
      person
      survey
    ] << [
      responses_attributes: %i[
        id
        lock_version
        _destroy
        submission_id
        question_id
      ] << [
        response: %i[
          id
          text
        ] << [
          answers: [],
          address: %i[
            id
            street
            street2
            city
            state
            zip
            country
          ],
          socialmedia: %i[
            id
            twitter
            facebook
            linkedin
            twitch
            youtube
            instagram
            website
            other
            tiktok
          ]
        ]
      ]
    ]
  end
end

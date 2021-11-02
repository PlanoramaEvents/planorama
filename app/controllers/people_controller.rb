class PeopleController < ResourceController
  SERIALIZER_CLASS = 'PersonSerializer'.freeze
  POLICY_CLASS = 'PeoplePolicy'.freeze
  POLICY_SCOPE_CLASS = 'PeoplePolicy::Scope'.freeze
  DEFAULT_ORDER = 'name_sort_by'

  # need to add includes etc to speed up query

  def me
    me = current_person
    authorize me, policy_class: policy_class
    # change type in serializer
    render_object(me, serializer: SessionSerializer)
  end

  #
  # Get a list of all the surveys that have been sent to the given person
  #
  def assigned_surveys
    authorize current_person, policy_class: policy_class

    collection = assigned_survey_collection
    collection_total = collection.size

    meta = {}
    meta[:total] = collection_total if paginate
    meta[:current_page] = @current_page if @current_page.present? && paginate
    meta[:perPage] = @per_page if @per_page.present? && paginate

    render json: SurveySerializer.new(collection,
                  {
                    meta: meta,
                    include: [
                      :survey_pages,
                      :'survey_pages.survey_questions',
                      :'survey_pages.survey_questions.survey_answers',
                      :survey_submissions
                    ],
                    params: {domain: "#{request.base_url}"}
                  }
                ).serializable_hash(),
           content_type: 'application/json'

  end

  def submissions
    authorize current_person, policy_class: policy_class

    collection = submissions_collection
    collection_total = collection.size

    meta = {}
    meta[:total] = collection_total if paginate
    meta[:current_page] = @current_page if @current_page.present? && paginate
    meta[:perPage] = @per_page if @per_page.present? && paginate

    render json: Survey::SubmissionSerializer.new(collection,
                  {
                    meta: meta,
                    include: [
                      :survey_responses
                    ],
                    params: {domain: "#{request.base_url}"}
                  }
                ).serializable_hash(),
           content_type: 'application/json'

  end

  def submissions_collection
    @per_page, @current_page, @filters = collection_params(do_paginate: false)

    person = Person.find params[:person_id]

    # TODO: tweak include to optimize query pre-fetch?
    q = person.survey_submissions
        .includes(
          [
            :survey_responses
          ]
        )
        .where(query(@filters))
        .order(order_string(order_by: 'survey_submissions.updated_at'))

    q
  end

  def assigned_survey_collection
    @per_page, @current_page, @filters = collection_params(do_paginate: false)

    person = Person.find params[:person_id]

    # TODO: tweak include to optimize query pre-fetch?
    q = person.mailed_surveys
        .includes(
          [
            {
              survey_pages: {
                survey_questions: :survey_answers
              }
            },
            :survey_submissions,
            :created_by,
            :updated_by,
            :published_by
          ]
        )
        .references(
          [
            :survey_submissions
          ]
        )
        .where("survey_submissions.person_id = ?", person.id) # limit the survey_submissions to those for the person ....
        .where(query(@filters))
        .order(order_string(order_by: 'mailings.updated_at'))

    q
  end

  def serializer_includes
    [
      :bio,
      :email_addresses,
      :person_roles
    ]
  end

  def includes
    [
      :email_addresses,
      :person_roles
    ]
  end

  # TODO: on create must have at least one email_addresses_attributes

  # def references
  #   [
  #   ]
  # end

  def except_params
    %i[
      bio
    ]
  end

  # def allowed_params
  #   %i[
  #     lock_version
  #     comments
  #     organization
  #     job_title
  #     pronouns
  #     year_of_birth
  #     gender
  #     ethnicity
  #     opted_in
  #     invite_status
  #     acceptance_status
  #     registered
  #     registration_type
  #     can_share
  #     registration_number
  #     can_photo
  #     can_record
  #     name
  #     name_sort_by
  #     name_sort_by_confirmed
  #     pseudonym
  #     pseudonym_sort_by
  #     pseudonym_sort_by_confirmed
  #   ] << [
  #     email_addresses_attributes: %i[
  #       id
  #       lock_version
  #       email
  #       isdefault
  #     ],
  #     person_roles_attributes: %i[
  #       id
  #       role
  #       _destroy
  #     ]
  #   ]
  # end
  # TODO: these to be dealt with in seperate controllers ??
  # tags
  # :bio
end

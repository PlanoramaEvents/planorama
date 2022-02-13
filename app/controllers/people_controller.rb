class PeopleController < ResourceController
  SERIALIZER_CLASS = 'PersonSerializer'.freeze
  POLICY_CLASS = 'PeoplePolicy'.freeze
  POLICY_SCOPE_CLASS = 'PeoplePolicy::Scope'.freeze
  DEFAULT_SORTBY = 'name_sort_by'

  # need to add includes etc to speed up query

  def me
    me = current_person
    authorize me, policy_class: policy_class
    # change type in serializer
    render_object(me,
      serializer: PersonSessionSerializer,
      jsonapi_included: [
        :email_addresses,
        :person_roles,
        :unsigned_agreements
      ]
    )
  end

  # email, name, pseudonym,
  def import
    authorize current_person, policy_class: policy_class

    sheet = params[:sheet]
    ignore_first_line = params[:ignore_first_line] #== 'true'
    count = 0
    sheet_length = sheet.length
    Person.transaction do
      sheet.each do |row|
        if ignore_first_line && count == 0
          count += 1
          next
        end

        email = row[0]
        name = row[1]
        pseudonym = row[2]

        if email && (email.length > 0)
          # validate that the email is a valid email
          email_validation = Truemail.validate(email, with: :regex)
          next unless email_validation.result.success

          # if we have a person with that email address as primary then skip the import
          found_email = EmailAddress.find_by(email: email, isdefault: true)
          next if found_email

          person = Person.create(
            name: name,
            name_sort_by: name,
            pseudonym: pseudonym,
            pseudonym_sort_by: pseudonym
          );
          email = EmailAddress.create(
            person: person,
            email: email,
            isdefault: true,
            is_valid: true
          );

          # By default we add the person as a member of the convention
          PersonRole.create(
            person: person,
            role: PersonRole.roles[:member]
          )

          count += 1
        end
      end
    end

    count = count - 1 if ignore_first_line
    message = "Imported #{count} people, skipped #{sheet_length - count}"

    render status: :ok,
           json: { message: message }.to_json,
           content_type: 'application/json'
  end

  #
  # Get a list of all the surveys that have been sent to the given person
  #
  def mailed_surveys
    authorize current_person, policy_class: policy_class

    collection = mailed_survey_collection(person_id: params[:person_id])
    collection_total = collection.size

    meta = {}
    meta[:total] = collection_total if paginate
    meta[:current_page] = @current_page if @current_page.present? && paginate
    meta[:perPage] = @per_page if @per_page.present? && paginate

    render json: SurveySerializer.new(collection,
                  {
                    meta: meta,
                    include: [
                      :pages,
                      :'pages.questions',
                      :'pages.questions.answers',
                      :submissions
                    ],
                    params: {
                      domain: "#{request.base_url}",
                      person_id: params[:person_id]
                    }
                  }
                ).serializable_hash(),
           content_type: 'application/json'
  end

  # For now mailed and assigned are the same, at some point they will not be
  def assigned_surveys
    authorize current_person, policy_class: policy_class

    do_paginate = false
    person = Person.find params[:person_id]
    # TODO: if the person is not allowed access use a scope to get their assigned surveys

    @per_page, @current_page, @filters = collection_params(do_paginate: do_paginate)

    collection = if do_paginate
                   person.assigned_surveys.page(@current_page).per(@per_page)
                 else
                   person.assigned_surveys
                 end

    meta = {}
    meta[:total] = collection_total if do_paginate
    meta[:current_page] = @current_page if @current_page.present? && do_paginate
    meta[:perPage] = @per_page if @per_page.present? && do_paginate

    render json: SurveySerializer.new(collection,
                  {
                    meta: meta,
                    include: [
                      :pages,
                      :'pages.questions',
                      :'pages.questions.answers'
                    ],
                    params: {
                      domain: "#{request.base_url}"
                    }
                  }
                ).serializable_hash(),
           content_type: 'application/json'
  end

  def submissions
    authorize current_person, policy_class: policy_class

    collection = submissions_collection(
      person_id: params[:person_id],
      survey_id: params[:survey_id]
    )
    collection_total = collection.size

    meta = {}
    meta[:total] = collection_total if paginate
    meta[:current_page] = @current_page if @current_page.present? && paginate
    meta[:perPage] = @per_page if @per_page.present? && paginate

    render json: Survey::SubmissionSerializer.new(collection,
                  {
                    meta: meta,
                    include: [
                      :responses
                    ],
                    params: {
                      domain: "#{request.base_url}",
                      person_id: params[:person_id],
                      survey_id: params[:survey_id]
                    }
                  }
                ).serializable_hash(),
           content_type: 'application/json'

  end

  def submissions_collection(person_id:, survey_id: nil)
    @per_page, @current_page, @filters = collection_params(do_paginate: false)

    person = Person.find person_id

    survey_query = nil
    if !survey_id.nil?
      survey_query = Survey.arel_table[:id].eq(survey_id)
    end

    # TODO: tweak include to optimize query pre-fetch?
    q = person.submissions
        .includes(
          [
            :responses
          ]
        )
        .joins(:survey)
        .where(survey_query)
        .where(query(@filters))
        .order(order_string(order_by: 'survey_submissions.updated_at'))

    q
  end

  def mailed_survey_collection(person_id:)
    @per_page, @current_page, @filters = collection_params(do_paginate: false)

    person = Person.find person_id

    # TODO: tweak include to optimize query pre-fetch?
    q = person.mailed_surveys
        .includes(
          [
            {
              pages: {
                questions: :answers
              }
            },
            :submissions,
            :created_by,
            :updated_by,
            :published_by
          ]
        )
        .references(
          [
            :submissions
          ]
        )
        .where("survey_submissions.person_id = ?", person.id) # limit the submissions to those for the person ....
        .where(query(@filters))
        .order(order_string(order_by: 'mailings.updated_at'))

    q
  end

  def serializer_includes
    [
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

  def references
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

  # def except_params
  #   %i[
  #   ]
  # end

  def allowed_params
    %i[
      id
      lock_version
      comments
      organization
      job_title
      pronouns
      year_of_birth
      gender
      ethnicity
      opted_in
      invite_status
      acceptance_status
      registered
      registration_type
      can_share
      registration_number
      can_photo
      can_record
      name
      name_sort_by
      name_sort_by_confirmed
      pseudonym
      pseudonym_sort_by
      pseudonym_sort_by_confirmed
      person_roles_attributes
      email_addresses_attributes
    ] << [
      email_addresses_attributes: %i[
        id
        lock_version
        email
        isdefault
      ],
      person_roles_attributes: %i[
        id
        role
        _destroy
      ]
    ]
  end
end

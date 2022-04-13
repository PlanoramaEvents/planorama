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
        :convention_roles,
        :unsigned_agreements,
        :session_limits
      ]
    )
  end

  # Mass update for the people (given ids and params)
  def update_all
    authorize current_person, policy_class: policy_class
    ids = params[:ids]
    attrs = params.permit(attrs: {})[:attrs].to_h #permit(:attrs)

    Person.transaction do
      # Get all the people with given set of ids and update them
      people = Person.where(id: ids).update(attrs)

      # return the updated people back to the caller
      options = {
        params: {
          domain: "#{request.base_url}",
          current_person: current_person
        }
      }

      render json: serializer_class.new(people,options).serializable_hash(),
             content_type: 'application/json'
    end
  end

  # email, name, pseudonym,
  def import
    authorize current_person, policy_class: policy_class

    sheet = params[:sheet]
    ignore_first_line = params[:ignore_first_line] #== 'true'
    count = 0
    sheet_length = sheet.length
    duplicate_email = 0
    bad_email = 0
    noname = 0
    errored_rows = []
    current_row_nbr = -1
    # TODO - we need to do a lock here .... (same for session)
    sheet.each do |row|
      current_row_nbr += 1
      if ignore_first_line && count == 0
        count += 1
        next
      end

      email = row[0].strip
      name = row[1].strip
      pseudonym = row[2].strip

      if email && (email.length > 0)
        # validate that the email is a valid email
        email_validation = Truemail.validate(email, with: :regex)
        bad_email += 1 unless email_validation.result.success
        errored_rows << current_row_nbr unless email_validation.result.success
        next unless email_validation.result.success

        # if we have a person with that email address as primary then skip the import
        found_email = EmailAddress.find_by(email: email, isdefault: true)

        errored_rows << current_row_nbr if found_email
        duplicate_email += 1 if found_email
        next if found_email

        noname += 1 if name && name.length == 0
        errored_rows << current_row_nbr if name && name.length == 0
        next if name && name.length == 0

        Person.transaction do
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
          ConventionRole.create(
            person: person,
            role: ConventionRole.roles[:participant]
          )
        end

        count += 1
      end
    end

    count = count - 1 if ignore_first_line
    message = {
      imported: "#{count}",
      skipped: "#{sheet_length - count}",
      bad_email: "#{bad_email}",
      duplicate_email: "#{duplicate_email}",
      noname: "#{noname}",
      other: "",
      errored_rows: errored_rows
    }

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
      :convention_roles
    ]
  end

  def includes
    [
      :email_addresses,
      :convention_roles,
      :availabilities,
      :session_limits
    ]
  end

  def references
    [
      :email_addresses,
      :convention_roles
    ]
  end

  # TODO: on create must have at least one email_addresses_attributes

  # def references
  #   [
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
      con_state
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
      convention_roles_attributes
      email_addresses_attributes
      bio
      website
      twitter
      othersocialmedia
      facebook
      linkedin
      twitch
      youtube
      instagram
      flickr
      reddit
      tiktok
      timezone
      twelve_hour
      attendance_type
      availability_notes
      ids
      attrs
    ] << [
      email_addresses_attributes: %i[
        id
        lock_version
        email
        is_valid
        isdefault
      ],
      convention_roles_attributes: %i[
        id
        group
        _destroy
      ]
    ]
  end
end

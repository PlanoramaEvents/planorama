class PeopleController < ResourceController
  SERIALIZER_CLASS = 'PersonSerializer'.freeze
  POLICY_CLASS = 'PersonPolicy'.freeze
  POLICY_SCOPE_CLASS = 'PersonPolicy::Scope'.freeze
  DEFAULT_SORTBY = 'name_sort_by'

  skip_before_action :authenticate_person!, only: [:check_password]
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
        :session_limits,
        :assigned_surveys
      ]
    )
  end

  # Need method to sync clyde for given person ...
  def clyde_sync
    authorize current_person, policy_class: policy_class

    person = Person.find params[:person_id]

    raise "No such person" unless person
    
    Person.transaction do
      identity = person.oauth_identities.where(provider: 'clyde').first

      reg_id = person.reg_id || identity&.reg_id
      
      raise "No Clyde Reg for given person" unless reg_id

      svc = ClydeService.get_svc(token: ENV['CLYDE_AUTH_KEY'])
      details = svc.person(id: reg_id)

      IdentityService.update_reg_info(person: person, details: details['data'])

      # Also need to update the datum
      update_datum(details['data'])

      render_object(person)
    end
  end

  def update_datum(data)
      datum = RegistrationSyncDatum.find_by reg_id: data['id']
      if datum
        datum.update(
            name: data['full_name']&.strip,
            email: data['email']&.strip,
            registration_number: data['ticket_number']&.strip,
            preferred_name: data['preferred_name']&.strip,
            alternative_email: data['alternative_email']&.strip,
            badge_name: data['badge']&.strip,
            raw_info: data
          )
      end
  end

  def unlink_registration 
    authorize current_person, policy_class: policy_class

    person = Person.find params[:person_id]

    raise "No such person" unless person
    # Remove the Oauth identity - needs to be destroy to remove the record
    person.oauth_identities.destroy_all
    # But we want to keep the Reg info if there is any
    # for admin and planners to see (not speakers)
    IdentityService.clear_person_reg_info(person: person)
    person.save!

    render_object(person)
  end

  def snapshot_schedule
    authorize current_person, policy_class: policy_class

    person = Person.find params[:person_id]

    if person
      label = params[:label]
      # We get the latest snapshot unless  a label was pass in
      sched = if !label.blank?
                PersonScheduleSnapshot
                  .joins(:schedule_snapshot)
                  .where( person: person.id)
                  .where('schedule_snapshots.label': label)
                  .order('updated_at desc').first
              else
                PersonScheduleSnapshot.where( person: person.id).order('updated_at desc').first
              end
      if !sched
        render json: {}, content_type: 'application/json'
      else
        render json: sched.snapshot, content_type: 'application/json'
      end
    end
  end

  def resync_airmeet
    authorize current_person, policy_class: policy_class

    person = Person.find params[:person_id]

    # makes the information in the airmeet sync record match the current person record
    # NOTE: DOES NOT ACTUALLY DO A SYNC TO AIRMEET
    if person
      AirmeetApiService.person_to_airmeet(person, true);
      # clumsily reload person after they are updated
      person = Person.find params[:person_id]
    end

    render_object(person)
  end

  def live_sessions
    authorize current_person, policy_class: policy_class

    person = Person.find params[:person_id]

    if person
      schedule = SessionService.draft_schedule_for(person: person, current_person: current_person, show_links: true)
      render json: schedule, content_type: 'application/json'
    end
  end

  # Get all the session names for the people ids passed in
  def session_names
    authorize current_person, policy_class: policy_class
    ids = params[:ids]

    moderator = SessionAssignmentRoleType.find_by(name: 'Moderator')
    participant = SessionAssignmentRoleType.find_by(name: 'Participant')
    invisible = SessionAssignmentRoleType.find_by(name: 'Invisible')

    allowed = [moderator.id, participant.id, invisible.id]

    people = Person.distinct
              .eager_load(session_assignments: :session)
              .where(
                "session_assignments.session_assignment_role_type_id in (?)",
                allowed
              )
              .where("people.id in (?)", ids)

    results = []

    people.each do |person|
      results << {
        person.id => person.session_assignments.select{|a| allowed.include?(a.session_assignment_role_type_id) }.collect{|sa| sa.session.title}
      }
    end

    # render result
    render json: results,
           content_type: 'application/json'
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

  # GET /auth/password/check/:password
  def check_password
    pwd = params[:password]

    raise "Invalid: password is blank" if pwd.blank?

    # does not contain email address
    raise "Invalid: password is an email" if pwd =~ URI::MailTo::EMAIL_REGEXP

    # does not contain word password
    # not part of common passwords
    raise "Invalid: password is not safe" if Pwned::Password.new(pwd, read_timeout: 5).pwned?

    # is not a recent password (not possible)
    if current_person
      current_person.password = pwd
      raise "Invalid: password was used in the past" if current_person.password_archive_included?
    end

    render json: { valid: true }, content_type: 'application/json'
  rescue => e
    Rails.logger.error "** BAD PASSWORD #{e}"
    render json: { valid: false, reason: e.message }, content_type: 'application/json'
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

  def completed_surveys
    authorize current_person, policy_class: policy_class

    person = Person.find params[:person_id]
    # Get the completed surveys for the persom
    collection = person.submitted_surveys.completed
    collection_total = collection.size

    # The JSON is just the top level survey data
    render json: SurveySerializer.new(collection,
                  {
                    params: {
                      domain: "#{request.base_url}",
                      person_id: params[:person_id],
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
      :convention_roles,
      :person_schedule_approvals,
      :session_limits
    ]
  end

  def includes
    [
      :email_addresses,
      :convention_roles,
      {person_schedule_approvals: {schedule_workflow: :schedule_snapshot}}
    ]
  end

  def references
    [
      :email_addresses,
      :convention_roles
      # {person_schedule_approvals: {schedule_workflow: :schedule_snapshot}}
    ]
  end

  def subquery(operation:, value:)
    if operation == 'unassigned'
      people = Arel::Table.new(Person.table_name)
      assignments = Arel::Table.new(SessionAssignment.table_name)

      people[:id].not_in(
        assignments.project(assignments[:person_id]).where(
          assignments[:session_id].eq(value)
        )
      )
    else
      nil
    end
  end

  def get_table(column:)
    if column.include?('draft_person_schedule_approvals')
      return PersonScheduleApproval.arel_table #.alias('draft_approvals')
    end
    if column.include?('firm_person_schedule_approvals')
      return PersonScheduleApproval.arel_table #.alias('firm_approvals')
    end

    return super(column: column)
  end

  def get_query_part(table:, column:, operation:, value:, top: false, key: nil)
    if key.include?('draft_person_schedule_approvals')
      return approval_query(table: table, column: column, operation: operation, value: value, label: 'draft')
    end
    if key.include?('firm_person_schedule_approvals')
      return approval_query(table: table, column: column, operation: operation, value: value, label: 'firm')
    end

    return super(table: table, column: column, operation: operation, value: value, top: top, key: key)
  end

  def approval_query(table:, column:, operation:, value:, label:)
    people = Person.arel_table
    schedule_snapshots = ScheduleSnapshot.arel_table
    schedule_workflows = ScheduleWorkflow.arel_table
    if value == 'not_set'
      people[:id].not_in(
        table.project(:person_id)
        .join(
          schedule_workflows,
          Arel::Nodes::OuterJoin
        )
        .on(table[:schedule_workflow_id].eq(schedule_workflows[:id]))
        .where(
          schedule_workflows[:state].eq(label)
            .and(
              table.grouping(
                table[:approved].eq('yes')).or(table[:approved].eq('no')
              )
            )
        )
      )
    else
      people[:id].in(
        table.project(:person_id)
        .join(
          schedule_workflows,
          Arel::Nodes::OuterJoin
        )
        .on(table[:schedule_workflow_id].eq(schedule_workflows[:id]))
        .where(
          schedule_workflows[:state].eq(label).and(table[:approved].eq(value))
        )
      )
    end
  end

  def derived_col?(col_name:)
    return true if col_name == 'session_count'
    false
  end

  def derived_table(col_name:)
    return Arel::Table.new('session_counts') if col_name == 'session_count'
    false
  end

  def select_fields
    Person.select(
      ::Person.arel_table[Arel.star],
      'session_counts.session_count'
    )
  end

  def join_tables
    people = Person.arel_table #Arel::Table.new(Session.table_name)

    session_counts = Person.session_counts.as('session_counts')
    joins = [
      people.create_join(
        session_counts,
        people.create_on(
          session_counts[:person_id].eq(people[:id])
        )
      )
    ]

    joins
  end

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
      can_photo_exceptions
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
      fediverse
      bsky
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
      can_stream
      can_stream_exceptions
      can_record_exceptions
      do_not_assign_with
      moderation_experience
      is_local
      languages_fluent_in
      demographic_categories
      excluded_demographic_categories
      global_diaspora
      non_anglophone
      age_at_convention
      romantic_sexual_orientation
      needs_accommodations
      accommodations
      willing_to_moderate
      othered
      indigenous
      black_diaspora
      non_us_centric_perspectives
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

class SessionsController < ResourceController
  SERIALIZER_CLASS = 'SessionSerializer'.freeze
  POLICY_CLASS = 'SessionPolicy'.freeze
  POLICY_SCOPE_CLASS = 'SessionPolicy::Scope'.freeze
  # DEFAULT_SORTBY = 'name_sort_by'

  def schedule_publish
    authorize current_person, policy_class: policy_class

    PublicationService.start_publish_job

    render status: :ok, json: {}.to_json, content_type: 'application/json'
  end

  def has_open_for_interest
    authorize current_person, policy_class: policy_class
      render json: {open_for_interest: Session.where(open_for_interest: true).count() > 0}
    end

  # Mass update for the sessions (given ids and params)
  def update_all
    authorize current_person, policy_class: policy_class
    ids = params[:ids]
    attrs = params.permit(attrs: {})[:attrs].to_h #permit(:attrs)

    Session.transaction do
      # Get all the people with given set of ids and update them
      people = Session.where(id: ids).update(attrs)

      # return the updated people back to the caller
      options = {
        include: serializer_includes,
        params: {
          domain: "#{request.base_url}",
          current_person: current_person
        }
      }

      render json: serializer_class.new(people,options).serializable_hash(),
             content_type: 'application/json'
    end
  end

  def express_interest
    # create a session assignment if there is not already one
    model_class.transaction do
      authorize @object, policy_class: policy_class

      # Find or create the session assignment
      # needs to change ....
      person = Person.find params[:person_id] if params[:person_id]
      person ||= current_person

      assignment = @object.session_assignments.for_person(person.id).first
      if assignment
        assignment.interested = true
        assignment.save!
      else
        assignment = SessionAssignment.create(
          person: person,
          session: @object,
          interested: true
        )
      end

      render_object(
        assignment,
        serializer: SessionAssignmentSerializer,
        jsonapi_included: []
      )
    end
  end

  # Import sessions from a sheet
  def import
    authorize current_person, policy_class: policy_class

    sheet = params[:sheet]
    ignore_first_line = params[:ignore_first_line]
    count = 0
    sheet_length = sheet.length
    errored_rows = []
    current_row_nbr = -1
    no_title = 0
    duplicate_session = 0
    sheet.each do |row|
      current_row_nbr += 1
      if ignore_first_line && count == 0
        count += 1
        next
      end

      areas = row[0].split(",")
      title = row[1]
      description = row[2]
      # format = row[3]
      goh_notes = row[4]
      interest_open = row[5]
      interest_instructions = row[6]
      tags = row[7]
      notes = row[8]

      # Rails.logger.debug("***** ROW #{row}")
      # Rails.logger.debug("***** ROW #{row[4]} - #{row[5]}")
      if title && (title.length > 0)
        # Rails.logger.error "***** #{title}"
        # Rails.logger.error "***** #{notes} \n #{goh_notes}"
        if Session.find_by title: title.strip
          errored_rows << current_row_nbr
          duplicate_session += 1
          next
        end

        format = Format.find_or_create_by(name: row[3].strip)

        Session.transaction do
          session = Session.create!(
            title: title.strip,
            description: description.strip,
            open_for_interest: interest_open && interest_open == 'Yes',
            instructions_for_interest: interest_instructions.strip,
            item_notes: [notes, goh_notes].join("\n").strip,
            format: format,
            duration: 60
          )

          # NOTE: we are not worried about tags as yet
          # tags

          primary = true
          areas.each do |area_name|
            area = Area.find_or_create_by(name: area_name.strip)
            SessionArea.create!(
              session: session,
              area: area,
              primary: primary
            )
            primary = false
          end
        end

        count += 1
      else
        errored_rows << current_row_nbr
        no_title += 1
      end
    end

    count = count - 1 if ignore_first_line
    message = "Imported #{count} sessions, skipped #{sheet_length - count}"

    message = {
      imported: "#{count}",
      skipped: "#{sheet_length - count}",
      no_title: "#{no_title}",
      duplicate_session: "#{duplicate_session}",
      other: "",
      errored_rows: errored_rows
    }


    render status: :ok,
           json: { message: message }.to_json,
           content_type: 'application/json'
  end

  def tags
    res = Session.tags_on(:tags).order(:name)

    render json: TagSerializer.new(res,
                  {
                    # include: serializer_includes,
                    params: {domain: "#{request.base_url}"}
                  }
                ).serializable_hash(),
           content_type: 'application/json'
  end

  def labels
    res = Session.tags_on(:labels).order(:name)

    render json: TagSerializer.new(res,
      {
        # include: serializer_includes,
        params: {domain: "#{request.base_url}"}
      }
    ).serializable_hash(),
    content_type: 'application/json'
  end

  def before_update
    # if time or room have changed removed ignored conflicts
    p = _permitted_params(model: object_name, instance: @object)
    if (@object.start_time || @object.room_id)
      if (p.has_key?('start_time') && p['start_time'] != @object.start_time) ||
          (p.has_key?('room_id') && p['room_id'] != @object.room_id)
        # so we remove any ignore conflicts for this session
        cids = @object.ignored_session_conflicts.pluck(:conflict_id)
        cids += @object.ignored_conflict_sessions.pluck(:conflict_id)
        IgnoredConflict.where(conflict_id: cids).delete_all
      end
    end
  end

  def serializer_includes
    [
      :format,
      :room,
      :room_set,
      :session_areas,
      :'session_areas.area'
      # Do not include assignment in the JSON by default as that can slow client down,
      # let client request them when needed
      # :session_assignments
    ]
  end

  def includes
    [
      :format,
      :room
    ]
  end

  def references
    [
      :format,
      :room
    ]
  end


  def eager_load
    [
      {session_areas: :area},
      # :areas,
      # :published_session,
      # {taggings: :tag}
    ]
  end

  def array_col?(col_name:)
    return true if col_name == 'area_list'
    return true if col_name == 'tags_array'
    return true if col_name == 'labels_array'
    false
  end

  def array_table(col_name:)
    return 'areas_list' if col_name == 'area_list'
    return 'tags_list_table' if col_name == 'tags_array'
    return 'labels_list_table' if col_name == 'labels_array'
    false
  end

  def join_tables
    sessions = Arel::Table.new(Session.table_name)
    published_sessions = Arel::Table.new(PublishedSession.table_name)

    subquery = Session.area_list.as('areas_list')
    tags_subquery = Session.tags_list_table.as('tags_list_table')
    labels_subquery = Session.labels_list_table.as('labels_list_table')
    conflict_counts = Session.conflict_counts.as('conflict_counts')
    joins = [
      sessions.create_join(
        subquery,
        sessions.create_on(
          subquery[:session_id].eq(sessions[:id])
        ),
        Arel::Nodes::OuterJoin
      ),
      sessions.create_join(
        tags_subquery,
        sessions.create_on(
          tags_subquery[:session_id].eq(sessions[:id])
        ),
        Arel::Nodes::OuterJoin
      ),
      sessions.create_join(
        labels_subquery,
        sessions.create_on(
          labels_subquery[:session_id].eq(sessions[:id])
        ),
        Arel::Nodes::OuterJoin
      ),
      sessions.create_join(
        conflict_counts,
        sessions.create_on(
          conflict_counts[:session_id].eq(sessions[:id])
        ),
        Arel::Nodes::OuterJoin
      ),
      sessions.create_join(
        published_sessions,
        sessions.create_on(
          published_sessions[:session_id].eq(sessions[:id])
        ),
        Arel::Nodes::OuterJoin
      )
    ]

    if @filters
      tags = Arel::Table.new(ActsAsTaggableOn::Tag.table_name)
      taggings = Arel::Table.new(ActsAsTaggableOn::Tagging.table_name)

      joins += [
        sessions.create_join(
          taggings,
          sessions.create_on(
            sessions[:id].eq(taggings[:taggable_id]).and(
              taggings[:taggable_type].eq('Session')
            )
          ),
          Arel::Nodes::OuterJoin
        ),
        taggings.create_join(
          tags,
          taggings.create_on(
            taggings[:tag_id].eq(tags[:id])
          ),
          Arel::Nodes::OuterJoin
        )
      ]
    end

    joins
  end

  def select_fields    
    Session.select(
      ::Session.arel_table[Arel.star],
      'conflict_counts.conflict_count',
      'areas_list.area_list',
      'tags_list_table.tags_array',
      'labels_list_table.labels_array',
      'published_sessions.session_id as is_published'
    )
  end

  def paginate
    !params[:perPage].blank?
  end

  def allowed_params
    %i[
      id
      lock_version
      format_id
      room_set_id
      title
      short_title
      description
      duration
      minimum_people
      maximum_people
      item_notes
      tech_notes
      pub_reference_number
      audience_size
      participant_notes
      is_break
      start_time
      visibility
      publish
      room_id
      open_for_interest
      instructions_for_interest
      tag_list
      label_list
      session_areas_attributes
      proofed
      format_id
      status
      environment
      minors_participation
      require_signup
      age_restriction_id
      room_notes
      recorded
      streamed
    ]
  end
end

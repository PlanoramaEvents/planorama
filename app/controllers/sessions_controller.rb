class SessionsController < ResourceController
  SERIALIZER_CLASS = 'SessionSerializer'.freeze
  POLICY_CLASS = 'SessionsPolicy'.freeze
  POLICY_SCOPE_CLASS = 'SessionsPolicy::Scope'.freeze
  # DEFAULT_SORTBY = 'name_sort_by'

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
            format: format
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

  def serializer_includes
    [
      :format,
      :room,
      :session_areas,
      :'session_areas.area'
    ]
  end

  def includes
    [
      :format,
      :room,
      :base_tags,
    ]
  end

  def references
    [
      :format,
      :room,
    ]
  end

  def eager_load
    [
      {session_areas: :area},
      :areas
    ]
  end

  def derived_col?(col_name:)
    return true if col_name == 'area_list'
    false
  end

  def array_col?(col_name:)
    return true if col_name == 'area_list'
    false
  end

  def array_table(col_name:)
    return 'areas_list' if col_name == 'area_list'
    false
  end

  def join_tables
    sessions = Arel::Table.new(Session.table_name)

    subquery = Session.area_list.as('areas_list')
    joins = [
      sessions.create_join(
        subquery,
        sessions.create_on(
          subquery[:session_id].eq(sessions[:id])
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

  def allowed_params
    %i[
      id
      lock_version
      format_id
      title
      description
      duration
      minimum_people
      maximum_people
      item_notes
      pub_reference_number
      audience_size,
      participant_notes
      is_break
      start_time
      visibility
      publish
      room_id
      open_for_interest
      instructions_for_interest
      tag_list
      session_areas_attributes
      proofed
      format_id
    ]
    # Tags
    # format
    # areas
  end
end

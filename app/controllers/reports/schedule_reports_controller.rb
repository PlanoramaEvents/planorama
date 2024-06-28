class Reports::ScheduleReportsController < ApplicationController
  around_action :set_timezone

  #
  # Get the sched diffs based on "publication dates"
  #
  def schedule_diff
    authorize Person, policy_class: Reports::ScheduleReportPolicy

    pd_from = PublicationDate.find params[:from] if params[:from]

    from = pd_from.timestamp if pd_from
    from ||= PublicationDate.order('created_at desc').first&.timestamp
    from ||= Time.now - 2.year

    pd_to = PublicationDate.find params[:to] if params[:to]
    to = pd_to.timestamp if pd_to
    live = false

    changes = if to
                ChangeService.published_changes(from: from, to: to)
              else
                live = true
                to ||= Time.now
                ChangeService.session_changes(from: from, to: to)
              end
    fully_dropped = ChangeService.dropped_people(from: from, to: to)

    workbook = FastExcel.open(constant_memory: true)
    init_sheets(workbook: workbook)

    # Rails.logger.debug "******** CHANGES: #{changes[:sessions]}"
    state_change_sessions = check_sessions_changed(
                              changes: changes[:sessions],
                              to: to,
                              live: live
                            )
    check_assignments_changed(
      changes: changes[:assignments],
      state_change_sessions: state_change_sessions,
      to: to
    )

    fully_dropped.uniq.each do |name|
      @participants_fully_dropped.append_row(name)
    end

    send_data workbook.read_string,
              filename: "ScheduleDiff-#{from.strftime('%m-%d-%Y_%H_%M')}_to_#{to.strftime('%m-%d-%Y_%H_%M')}.xlsx",
              disposition: 'attachment'
  end

  #
  #
  #
  def check_sessions_changed(changes:, to:, live:)
    state_change_sessions = []
    changes.values.sort{|a,b| (a[:object] ? a[:object].title : '') <=> (b[:object] ? b[:object].title : '')}.each do |change|
      next unless change[:object]

      if change[:object] && session_status_change_to_publishable?(change: change) || session_status_change_to_drop?(change: change)
        state_change_sessions << change[:object].id
      end

      if (change[:changes]['room_id'] || change[:changes]['start_time']) #&& !change[:changes]['status']
        next if ignore_session_status_change?(change: change)
        next if live && !change[:changes]['status'] && ['draft', 'dropped'].include?(change[:recent].status)

        # If either room or time was added to the session
        if room_added?(change) || start_time_added?(change)
          session_added_row(@session_added, change, to)
          live_add(change: change, sheet: @participants_add_drop) if live
          next
        end

        # If either room or time was removed to the session
        if room_removed?(change) || start_time_removed?(change)
          session_removed_row(@session_removed, change)
          live_drop(session: change[:object], sheet: @participants_add_drop) if live
          next
        end

        # If the room was changed
        if change[:changes]['room_id']
          session_room_change_row(@session_room_changed, change)
        end

        # If the time was changed
        if change[:changes]['start_time']
          session_time_change_row(@session_time_changed, change)
        end
      end

      # If the object is scheduked and title or description was changed
      # We need the object as it is now???
      if change[:object].start_time && change[:object].room_id
        check_status_change(change: change, to: to, live: live)

        if change[:changes]['title']
          session_title_change_row(@session_title_changed, change)
        end
        if change[:changes]['description']
          session_description_change_row(@session_description_changed, change)
        end
      end
    end

    # Rails.logger.debug "*********** ST #{state_change_sessions}"
    return state_change_sessions
  end

  def room_added?(change)
    return false unless change[:changes] && change[:changes]['room_id']

    !change[:changes]['room_id'][0] && change[:changes]['room_id'][1]
  end

  def start_time_added?(change)
    return false unless change[:changes] && change[:changes]['start_time']

    !change[:changes]['start_time'][0] && change[:changes]['start_time'][1]
  end

  def room_removed?(change)
    return false unless change[:changes] && change[:changes]['room_id']

    change[:changes]['room_id'][0] && !change[:changes]['room_id'][1]
  end

  def start_time_removed?(change)
    return false unless change[:changes] && change[:changes]['start_time']

    change[:changes]['start_time'][0] && !change[:changes]['start_time'][1]
  end

  def check_assignments_changed(changes:, state_change_sessions:, to:)
    moderator = SessionAssignmentRoleType.find_by(name: 'Moderator')
    participant = SessionAssignmentRoleType.find_by(name: 'Participant')
    roles = [moderator.id, participant.id]

    changes.each do |id, change|
      changed_assignment = change[:recent]
      changed_assignment ||=  SessionAssignment.find(id) if SessionAssignment.exists?(id)

      next unless changed_assignment
      next if state_change_sessions.include?(changed_assignment.session_id || changed_assignment.published_session_id)

      session = ChangeService.session_as_of(session_id: changed_assignment.session_id, to: to)
      next unless session

      person ||= changed_assignment.person
      next unless person

      # Participants add/drop
      if change[:changes]['session_assignment_role_type_id'] && change[:event] != 'destroy'
        if session.start_time && session.room_id
          if (roles.include?(change[:changes]['session_assignment_role_type_id'][1]))
            @participants_add_drop.append_row(
              [
                session.title,
                '',
                person.published_name
              ]
            )
          elsif (roles.include?(change[:changes]['session_assignment_role_type_id'][0]))
            @participants_add_drop.append_row(
              [
                session.title,
                person.published_name,
              ]
            )
          end
        end
      else
        # Rails.logger.debug "******** Assignment EVENT DROP ????"
        if change[:event] == 'destroy'
          @participants_add_drop.append_row(
            [
              session.title,
              person.published_name,
            ]
          )
        end
      end
    end
  end

  def check_status_change(change:, to:, live: false)
    return unless change[:changes]['status']
    return if ignore_session_status_change?(change: change)

    if session_status_change_to_drop?(change: change)
      live_drop(session: change[:object], sheet: @participants_add_drop) if live
      session_removed_row(@session_removed, change)

      return
    end

    if session_status_change_to_publishable?(change: change)
      # Rails.logger.debug "********* STATUS CHANGE ..... ADDD #{live}"
      session_added_row(@session_added, change, to)
      live_add(change: change, sheet: @participants_add_drop) if live

      return
    end
  end

  def ignore_session_status_change?(change:)
    change[:changes]['status'] && ['draft', 'dropped'].include?(change[:changes]['status'][0]) && ['draft', 'dropped'].include?(change[:changes]['status'][1])
  end

  def session_status_change_to_publishable?(change:)
    change[:changes]['status'] && ['draft', 'dropped'].include?(change[:changes]['status'][0]) && ['reviewed', 'revised'].include?(change[:changes]['status'][1])
  end

  def session_status_change_to_drop?(change:)
    change[:changes]['status'] && ['draft', 'dropped'].include?(change[:changes]['status'][1]) && ['reviewed', 'revised'].include?(change[:changes]['status'][0])
  end

  def init_sheets(workbook:)
    @session_time_changed = workbook.add_worksheet("Session Time Changed")
    @session_room_changed = workbook.add_worksheet("Session Room Changed")
    @session_title_changed = workbook.add_worksheet("Session Title Changed")
    @session_description_changed = workbook.add_worksheet("Session Description Changed")
    @session_added = workbook.add_worksheet("Sessions Add")
    @session_removed = workbook.add_worksheet("Sessions Removed")
    @participants_fully_dropped = workbook.add_worksheet("Participants Dropped")
    @participants_add_drop = workbook.add_worksheet("Participants Add Drop")

    @date_time_style = workbook.number_format(EXCEL_NBR_FORMAT)
    tab_headers
  end

  def tab_headers
    @session_time_changed.append_row(['Session Title','Original Start Time', 'New Start Time'])
    @session_room_changed.append_row(['Session Title','Original Room', 'New Room'])
    @session_title_changed.append_row(['Original Session Title', 'New Session Title'])
    @session_description_changed.append_row(['Session Title','Original Description', 'New Description'])
    @session_added.append_row(['Session Id', 'Session Title', 'Session Description', 'Format', 'Areas', 'Start Time', 'Room', 'Moderators', 'Participants'])
    @session_removed.append_row(['Session Title'])

    @participants_add_drop.append_row(['Session Title', 'Participant Dropped', 'Participant Added'])
    @participants_fully_dropped.append_row(['Participant Dropped'])
  end

  def live_add(change:, sheet:)
    object = change[:item_type].constantize.find change[:item_id]
    return unless object.start_time && object.room_id

    object.participant_assignments.each do |sa|
      sheet.append_row(
        [
          object.title,
          '',
          sa.person.published_name,
        ]
      )
    end
  end

  def live_drop(session:, sheet:)
    session.participant_assignments.each do |sa|
      sheet.append_row(
        [
          session.title,
          sa.person.published_name,
        ]
      )
    end
  end

  def session_description_change_row(sheet, change)
    sheet.append_row(
      [
        change[:object].title,
        change[:changes]['description'][0],
        change[:changes]['description'][1]
      ]
    )
  end

  def session_title_change_row(sheet, change)
    sheet.append_row(
      [
        change[:changes]['title'][0],
        change[:changes]['title'][1]
      ]
    )
  end

  def session_room_change_row(sheet, change)
    orig_room = Room.find change[:changes]['room_id'][0] if change[:changes]['room_id'][0]
    new_room = Room.find change[:changes]['room_id'][1] if change[:changes]['room_id'][1]
    sheet.append_row(
      [
        change[:object].title,
        orig_room&.name,
        new_room&.name
      ]
    )
  end

  def session_removed_row(sheet, change)
    sheet.append_row(
      [
        change[:object].title
      ]
    )
  end

  def session_time_change_row(sheet, change)
    return unless change[:recent]

    orig_time = Time.parse(change[:changes]['start_time'][0]) if change[:changes]['start_time'][0]
    new_time = Time.parse(change[:changes]['start_time'][1]) if change[:changes]['start_time'][1]
    # Rails.logger.debug "********* #{change[:changes]['start_time'][1]} =>  #{new_time.class} #{new_time.strftime("%H")}"
    sheet.append_row(
      [
        change[:recent].title,
        orig_time ? FastExcel.date_num(orig_time, orig_time.in_time_zone.utc_offset) : nil,
        new_time ? FastExcel.date_num(new_time, new_time.in_time_zone.utc_offset) : nil
      ],
      [
        nil, @date_time_style, @date_time_style
      ]
    )
  end

  # Generate a row for sessions added
  def session_added_row(sheet, change, to)
    moderator = SessionAssignmentRoleType.find_by(name: 'Moderator')
    participant = SessionAssignmentRoleType.find_by(name: 'Participant')

    # If it is an add and we have the reify before the time and room get the latest version of the object
    object = ChangeService.session_as_of(session_id: change[:item_id], to: to)
    return unless object.start_time && object.room_id

    # Get the assignments at the time of change
    assignments = ChangeService.assignments_as_of(session_id: change[:item_id], to: to)

    sheet.append_row(
      [
        object.id,
        object.title,
        object.description,
        object.format&.name,
        object.areas.collect(&:name).join("; "),
        FastExcel.date_num(object.start_time, object.start_time.in_time_zone.utc_offset),
        object.room&.name,
        assignments[:moderators].collect{|a| a.person.published_name}.join("; "),
        assignments[:participants].collect{|a| a.person.published_name}.join("; ")
      ],
      [
        nil, nil, nil, nil, @date_time_style, nil, nil, nil
      ]
    )
  end
end

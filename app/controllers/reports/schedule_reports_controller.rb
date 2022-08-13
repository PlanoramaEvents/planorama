class Reports::ScheduleReportsController < ApplicationController
  around_action :set_timezone

  def schedule_diff
    authorize Person, policy_class: Reports::ScheduleReportPolicy

    # TODO: base the from and to on the publish ids and this will be ok as a get
    pd_from = PublicationDate.find params[:from] if params[:from]

    from = pd_from.timestamp if pd_from
    from ||= PublicationDate.order('created_at desc').first&.timestamp
    from ||= Time.now - 2.year # TODO: for testing

    pd_to = PublicationDate.find params[:to] if params[:to]
    to = pd_to.timestamp if pd_to

    # changes = ChangeService.published_changes(from: from, to: to)
    changes = if to
                ChangeService.published_changes(from: from, to: to)
              else
                ChangeService.session_changes(from: from)
              end

    to ||= Time.now
    workbook = FastExcel.open(constant_memory: true)
    date_time_style = workbook.number_format(EXCEL_NBR_FORMAT)

    session_time_changed = workbook.add_worksheet("Session Time Changed")
    session_room_changed = workbook.add_worksheet("Session Room Changed")
    session_title_changed = workbook.add_worksheet("Session Title Changed")
    session_description_changed = workbook.add_worksheet("Session Description Changed")
    session_added = workbook.add_worksheet("Sessions Add")
    session_removed = workbook.add_worksheet("Sessions Removed")

    participants_fully_dropped = workbook.add_worksheet("Participants Dropped")
    participants_add_drop = workbook.add_worksheet("Participants Add Drop")

    tab_headers(session_time_changed, session_room_changed, session_title_changed, session_description_changed, session_added, session_removed, participants_add_drop, participants_fully_dropped)

    # Rails.logger.debug "******** CHANGES: #{changes[:sessions]}"

    # test
    changes[:sessions].values.sort{|a,b| (a[:object] ? a[:object].title : '') <=> (b[:object] ? b[:object].title : '')}.each do |change|
      # Rails.logger.debug "******** CHANGE: #{change}"
      next unless change[:object]

      if change[:changes]['room_id'] || change[:changes]['start_time']
        if change[:changes]['room_id'] && change[:changes]['start_time'] &&
          ((!change[:changes]['room_id'][0] && change[:changes]['room_id'][1]) ||
          (!change[:changes]['start_time'][0] && change[:changes]['start_time'][1]))
          session_added_row(session_added, change, date_time_style)
          next
        else
          if (change[:changes]['room_id'] && !change[:changes]['room_id'][1]) || (change[:changes]['start_time'] && !change[:changes]['start_time'][1])|| change[:event] == 'destroy'
            # Rails.logger.debug "******** removed because room or time"
            session_removed_row(session_removed, change)
            next
          else
            if change[:changes]['room_id']
              session_room_change_row(session_room_changed, change)
            end
            if change[:changes]['start_time']
              session_time_change_row(session_time_changed, change, date_time_style)
            end
          end
        end
      end

      if change[:changes]['status']
        if (change[:changes]['status'][1] == 'draft' || change[:changes]['status'][1] == 'dropped') && change[:object].start_time && change[:object].room_id
          # Rails.logger.debug "******** removed because draft"
          session_removed_row(session_removed, change)
          next
        elsif (change[:changes]['status'][0] == 'draft' || change[:changes]['status'][0] == 'dropped') && change[:object].start_time && change[:object].room_id
          # Rails.logger.debug "******** added because state change"
          session_added_row(session_added, change, date_time_style)
          next
        end
      end

      if change[:changes]['title']
        session_title_change_row(session_title_changed, change)
      end
      if change[:changes]['description']
        session_description_change_row(session_description_changed, change)
      end
    end

    moderator = SessionAssignmentRoleType.find_by(name: 'Moderator')
    participant = SessionAssignmentRoleType.find_by(name: 'Participant')
    roles = [moderator.id, participant.id]
    # Rails.logger.debug "******** ROLES #{roles}"

    # TODO: sort .... ??? how
    fully_dropped = []
    changes[:assignments].each do |id, change|
      next unless change[:object]

      # Participants add/drop
      if change[:changes]['session_assignment_role_type_id']
        session = change[:object].session if change[:object].session
        session ||= Session.find change[:object].session_id
        if (roles.include?(change[:changes]['session_assignment_role_type_id'][1]))
          participants_add_drop.append_row(
            [
              session.title,
              '',
              change[:object].person.published_name
            ]
          )
        elsif (roles.include?(change[:changes]['session_assignment_role_type_id'][0]))
          participants_add_drop.append_row(
            [
              session.title,
              change[:object].person.published_name,
            ]
          )
          if change[:object].person.sessions.scheduled.count == 0
            fully_dropped.append [change[:object].person.published_name]
          end
        end
      end
    end

    fully_dropped.uniq.each do |name|
      participants_fully_dropped.append_row(name)
    end

    send_data workbook.read_string,
              filename: "ScheduleDiff-#{from.strftime('%m-%d-%Y_%H_%M')}_to_#{to.strftime('%m-%d-%Y_%H_%M')}.xlsx",
              disposition: 'attachment'
  end

  def tab_headers(session_time_changed, session_room_changed, session_title_changed, session_description_changed, session_added, session_removed, participants_add_drop, participants_fully_dropped)
    session_time_changed.append_row(['Session Title','Original Start Time', 'New Start Time'])
    session_room_changed.append_row(['Session Title','Original Room', 'New Room'])
    session_title_changed.append_row(['Original Session Title', 'New Session Title'])
    session_description_changed.append_row(['Session Title','Original Description', 'New Description'])
    session_added.append_row(['Session Title', 'Session Description', 'Format', 'Areas', 'Start Time', 'Room', 'Moderators', 'Participants'])
    session_removed.append_row(['Session Title'])

    participants_add_drop.append_row(['Session Title', 'Participant Dropped', 'Participant Added'])
    participants_fully_dropped.append_row(['Participant Dropped'])
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
    # TODO: if it is a destroy ....
    sheet.append_row(
      [
        change[:object].title
      ]
    )
  end

  def session_time_change_row(sheet, change, date_time_style)
    orig_time = Time.parse(change[:changes]['start_time'][0]) if change[:changes]['start_time'][0]
    new_time = Time.parse(change[:changes]['start_time'][1]) if change[:changes]['start_time'][1]
    # Rails.logger.debug "********* #{change[:changes]['start_time'][1]} =>  #{new_time.class} #{new_time.strftime("%H")}"
    sheet.append_row(
      [
        change[:object].title,
        orig_time ? FastExcel.date_num(orig_time, orig_time.in_time_zone.utc_offset) : nil,
        new_time ? FastExcel.date_num(new_time, new_time.in_time_zone.utc_offset) : nil
      ],
      [
        nil, date_time_style, date_time_style
      ]
    )
  end

  # Generate a row for sessions added
  def session_added_row(sheet, change, date_time_style)
    moderator = SessionAssignmentRoleType.find_by(name: 'Moderator')
    participant = SessionAssignmentRoleType.find_by(name: 'Participant')

    sheet.append_row(
      [
        change[:object].title,
        change[:object].description,
        change[:object].format&.name,
        change[:object].areas.collect(&:name).join("; "),
        FastExcel.date_num(change[:object].start_time, change[:object].start_time.in_time_zone.utc_offset),
        change[:object].room&.name,
        change[:object].participant_assignments.where("session_assignment_role_type_id = ?", moderator).collect{|a| a.person.published_name}.join("; "),
        change[:object].participant_assignments.where("session_assignment_role_type_id = ?", participant).collect{|a| a.person.published_name}.join("; ")
      ],
      [
        nil, nil, nil, nil, date_time_style, nil, nil, nil
      ]
    )
  end
end

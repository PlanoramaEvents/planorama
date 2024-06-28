require 'csv'
class RceController < ApplicationController
  # All time need to be in the convention timezone
  around_action :set_timezone

  def schedule
    authorize Session, policy_class: RcePolicy

    # Need to get sessions that are online or hybrid ...
    # and/or streamed
    sessions = SessionService.scheduled_sessions.where(
        "environment in (?) or streamed = true", ['hybrid', 'virtual']
      )

    send_data generate_csv(sessions),
              filename: "schedule-#{Time.now.strftime('%m-%d-%Y')}.csv",
              disposition: 'attachment'
  end

  def generate_csv(sessions)
    column_names = [
        'Start date','Start time','End date','End time',
        'Schedule name','Schedule description','Segment name','Segment type',
        'Tags','Attendance',
        'Event type', 'Room'
      ]

    CSV.generate do |csv|
      csv << column_names

      sessions.each do |session|
        # Session has an online audience only if it is streamed or virtual (online)
        next unless session.environment == 'virtual' || session.streamed
        # If the room is not an online room or an RCE stage then there is no online audience
        next unless session.room.integrations["rce"] && session.room.integrations["rce"]["SegmentType"]

        description = session.description
        segmentType = session.room.integrations["rce"] ? session.room.integrations["rce"]["SegmentType"] : "sessions"
        if segmentType != "stage"
          description = ActionView::Base.full_sanitizer.sanitize(description)
        end

        csv << [
          session.start_time.strftime("%Y-%m-%d"),
          session.start_time.strftime("%H:%M"),
          (session.start_time + session.duration.minutes).strftime("%Y-%m-%d"),
          (session.start_time + session.duration.minutes).strftime("%H:%M"),
          session.title,
          # if the session is a "session" then strip the HTML
          description, # HTML may be an issue ...
          # Segment Name, room if stage or title if session
          segmentType != "stage" ? session.title : session.room.name,
          # Segment Type
          segmentType,
          # Areas and tags
          "#{session.area_list.sort.join(', ')}, #{session.tag_list&.join(', ')}", # Tags may be new line seperated?
          'regular',
          # If is a stage then it is "hybrid" and we set Event Tyep and the Room name !!!
          segmentType == "stage" ? 'hybrid' : 'virtual',
          segmentType == "stage" ? session.room.name : '',
        ]
      end
    end
  end
end

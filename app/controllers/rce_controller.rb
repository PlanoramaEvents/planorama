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
        'Tags','Attendance'
      ]

    CSV.generate do |csv|
      csv << column_names

      sessions.each do |session|
        next unless session.room.integrations["rce"]

        csv << [
          session.start_time.strftime("%Y-%m-%d"),
          session.start_time.strftime("%H:%M"),
          (session.start_time + session.duration.minutes).strftime("%Y-%m-%d"),
          (session.start_time + session.duration.minutes).strftime("%H:%M"),
          session.title,
          session.description, # HTML may be an issue ...
          session.title,
          session.room.integrations["rce"] ? session.room.integrations["rce"]["SegmentType"] : "sessions",
          # Areas and tags
          "#{session.area_list.sort.join(', ')}, #{session.tag_list&.join(', ')}", # Tags may be new line seperated?
          'regular'
        ]
      end
    end
  end
end

require 'csv'
class RceController < ApplicationController
  # All time need to be in the convention timezone
  around_action :set_timezone

  def schedule
    authorize Session, policy_class: RcePolicy

    sessions = SessionService.scheduled_sessions

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
        csv << [
          session.start_time.strftime("%Y-%m-%d"),
          # "2024-07-19",
          session.start_time.strftime("%H:%M"),
          (session.start_time + session.duration.minutes).strftime("%Y-%m-%d"),
          # "2024-07-19",
          (session.start_time + session.duration.minutes).strftime("%H:%M"),
          session.title,
          session.description, # HTML may be an issue ...
          session.title,
          'sessions',
          # Areas and tags
          "#{session.area_list.sort.join(', ')}, #{session.tags_array&.join(', ')}", # Tags may be new line seperated?
          'regular'
        ]
      end
    end
  end
end

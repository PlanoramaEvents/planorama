class PublicationsController < ApplicationController
  around_action :set_timezone

  def schedule
    sessions = ReportsService.scheduled_sessions

    send_data XmlFormatter.new(sessions).render('schedule', sessions),
              filename: "schedule.xml",
              disposition: 'attachment'
  end

  def set_timezone(&block)
    timezone = ConfigService.value('convention_timezone')
    Time.use_zone(timezone, &block)
  end
end

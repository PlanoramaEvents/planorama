class PublicationsController < ApplicationController
  around_action :set_timezone

  def schedule
    sessions = ReportsService.scheduled_sessions

    send_data XmlFormatter.new(sessions).render('schedule', sessions)
    .gsub(/\<\?xml version="1\.0"\?\>\n/, '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><!-- Formatted for the special requirements of importing to Adobe InDesign. -->')
    .gsub(/\<schedule\>\n  /, '<schedule>')
    .gsub(/\<session\>\n    /, '<session>')
    .gsub(/      \</, '<')
    .gsub(/    \</, '<')
    .gsub(/  \</, '<')
    .gsub(/\n\<start_time\>/, '<start_time>')
    .gsub(/\n\<duration\>/, ' - <duration>')
    .gsub(/\<\/duration\>/, ' minutes</duration>')
    .gsub(/\n\<\/timeduration\>/, '</timeduration>')
    .gsub(/\n\<room\>/, '<room>')
    .gsub(/\n\<areas\>/, ' - <areas>')
    .gsub(/\n\<format\>/, ', <format>')
    .gsub(/\n\<\/roomareasformat\>/, '</roomareasformat>')
    .gsub(/\<participants\>\n/, '<participants>')
    .gsub(/\<person\>\n/, '<person>')
    .gsub(/\n\<person\>/, '<person>')
    .gsub(/\\n  <role\>/, '<role>')
    .gsub(/\<role\>Participant\<\/role>/, '')
    .gsub(/\<\/person\>\<role\>/, '</person> <role>')
    .gsub(/\<\/person\>\<person\>/, '</person>, <person>')
    .gsub(/\<\/participants\>\n/, '</participants>')
    .gsub(/\<\/name\>\n/, '</name>')
    .gsub(/\n\<\/person\>/, '</person>')
    .gsub(/\n\<\/participants\>/, '</participants>')
    .gsub(/\<role\>Participant\<\/role>/, '')
    .gsub(/\<role\>Moderator\<\/role>/, ' <role>(Moderator)</role>')
    .gsub(/\n\<\/session\>/, '</session>')
    .gsub(/\n\<\/schedule\>\n/, '</schedule>'),
              filename: "schedule.xml",
              disposition: 'attachment'
  end

  def set_timezone(&block)
    timezone = ConfigService.value('convention_timezone')
    Time.use_zone(timezone, &block)
  end
end

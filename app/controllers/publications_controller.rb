class PublicationsController < ApplicationController
  around_action :set_timezone

  def schedule
    # use published if any otherwise use live
    sessions = if PublishedSession.count > 0
                 SessionService.published_sessions
                else
                  SessionService.live_sessions
                end

    # TODO - check this
    send_data XmlFormatter.new(sessions).render('schedule', sessions)
    .gsub(/&lt;em&gt;/, '<em>')
    .gsub(/&lt;\/em&gt;/, '</em>')
    .gsub(/\<\?xml version="1\.0"\?\>\n/, '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><!-- Formatted for the special requirements of importing to Adobe InDesign. -->')
    .gsub(/\<schedule\>\n  /, '<schedule>')
    .gsub(/\<session\>\n    /, '<session>')
    .gsub(/      \</, '<')
    .gsub(/    \</, '<')
    .gsub(/  \</, '<')
    .gsub(/\<id\>(\d+)\<\/id\>\n\<title>/, '<title><id>\1</id> | ')
    .gsub(/\n\<start_time\>/, '<start_time>')
    .gsub(/\n\<duration\>/, ' - <duration>')
    .gsub(/\<\/duration\>/, ' minutes</duration>')
    .gsub(/\n\<\/timeduration\>/, '</timeduration>')
    .gsub(/\n\<room\>/, '<room>')
    .gsub(/\n\<areas\>/, ' - <areas>')
    .gsub(/\n\<tags\>/, '<tags>')
    .gsub(/\n\<format\>/, ', <format>')
    .gsub(/\n\<\/roomareasformattags\>/, '</roomareasformattags>')
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

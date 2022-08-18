module Formatter
  module PersonSchedule

    def schedule_to_html(person:)
      html = ""

      sessions = person.scheduled_sessions.not_draft.order('start_time asc')

      sessions.each do |session|
        html += "<p><b>#{session.title}</b> #{session.room.name}, #{session.start_time.strftime('%A, %B %-d, %l:%M %P %Z')}</p>"
      end

      return html
    end

  end
end

class SiteConfig < ApplicationRecord
  # def adjust_dates_with_timezone
  #   Time.use_zone(self.time_zone) do
  #     if self.public_start_date.present?
  #       self.public_start_date = (self.public_start_date.in_time_zone - self.tz_offset_seconds)
  #     end
  #     if self.public_end_date.present?
  #       self.public_end_date = (self.public_end_date.in_time_zone - self.tz_offset_seconds)
  #     end
  #
  #     if self.read_start_date.present?
  #       self.start_date = (self.start_date.in_time_zone - self.tz_offset_seconds)
  #     end
  #     if self.read_end_date.present?
  #       self.end_date = (self.end_date.in_time_zone - self.tz_offset_seconds)
  #     end
  #   end
  #   self.save!
  # end
  #
  # def tz_offset
  #   if tz_offset_seconds.present?
  #     tz_offset_seconds / 60
  #   else
  #     0
  #   end
  # end
  #
  # def tz_offset_seconds
  #   if self.start_date.present?
  #     offset = self.start_date.in_time_zone(self.time_zone).utc_offset
  #   elsif self.public_start_date.present?
  #     offset = self.public_start_date.in_time_zone(self.time_zone).utc_offset
  #   else
  #     offset = 0
  #   end
  #   offset
  # end
  #
  # def start_date
  #   _start_date = read_start_date
  #   if _start_date.blank? && public_start_date.present?
  #     _start_date = public_start_date
  #   end
  #
  #   _start_date
  # end
  #
  # def end_date
  #   _end_date = read_end_date
  #   if _end_date.blank? && public_end_date.present?
  #     _end_date = public_end_date
  #   end
  #
  #   _end_date
  # end
  #
  # def read_start_date
  #   self[:start_date]
  # end
  #
  # def read_end_date
  #   self[:end_date]
  # end
  #
  # # before save check that the public dates etc are within the time period
  # # def check_public_dates
  # #   raise I18n.t("planner.core.errors.messages.public-dates-not-in-range") if public_start_date < start_date
  # #   if number_of_days > 0
  # #     raise I18n.t("planner.core.errors.messages.public-dates-not-in-range") if public_end_date > end_date
  # #   end
  # # end
  #
  # def number_of_days
  #   Time.use_zone(self.time_zone) do
  #     if end_date && start_date
  #       (end_date.in_time_zone.to_date - start_date.in_time_zone.to_date).to_i + 1
  #     else
  #       0
  #     end
  #   end
  # end
  #
  # def public_number_of_days
  #   Time.use_zone(self.time_zone) do
  #     if public_end_date && public_start_date
  #       (public_end_date.in_time_zone.to_date - public_start_date.in_time_zone.to_date).to_i + 1
  #     else
  #       0
  #     end
  #   end
  # end
  #
  # def on_now?
  #   Time.use_zone(self.time_zone) do
  #     if self.start_date.present? && self.end_date.present?
  #       start_date.in_time_zone <= Time.current && end_date.in_time_zone >= Time.current
  #     else
  #       false
  #     end
  #   end
  # end
  #
  # def on_now_for_public?
  #   Time.use_zone(self.time_zone) do
  #     if self.public_start_date.present?
  #       public_start_date.in_time_zone <= Time.current && public_end_date.in_time_zone >= Time.current
  #     else
  #       false
  #     end
  #   end
  # end
  #
  # def has_finished?
  #   Time.use_zone(self.time_zone) do
  #     if self.end_date.present?
  #       end_date.in_time_zone < Time.current
  #     else
  #       false
  #     end
  #   end
  # end
  #
  # def has_finished_for_public?
  #   Time.use_zone(self.time_zone) do
  #     if self.public_end_date.present?
  #       public_end_date.in_time_zone < Time.current
  #     else
  #       false
  #     end
  #   end
  # end
  #
  # def in_future?
  #   Time.use_zone(self.time_zone) do
  #     if self.start_date.present?
  #       start_date.in_time_zone > Time.current
  #     else
  #       false
  #     end
  #   end
  # end
  #
  # def in_future_for_public?
  #   Time.use_zone(self.time_zone) do
  #     if self.start_date.present?
  #       public_start_date.in_time_zone > Time.current
  #     else
  #       false
  #     end
  #   end
  # end
  #
  # def end_dates_the_same?
  #   end_date == public_end_date
  # end
  #
  # def start_dates_the_same?
  #   start_date == public_start_date
  # end
  #
  # def pub_dates_the_same?
  #   start_dates_the_same? && end_dates_the_same?
  # end
  #
  # def single_date_event?
  #   duration_in_hours <= 24
  # end
  #
  # def single_public_date_event?
  #   public_duration_in_hours <= 24
  # end
  #
  # def all_day_event?
  #   Time.use_zone(self.time_zone) do
  #     if self.start_date.present?
  #       (public_start_date.in_time_zone.beginning_of_day - public_start_date.in_time_zone).to_i <= 60 &&
  #       (public_end_date.in_time_zone.end_of_day - public_end_date.in_time_zone).to_i <= 60
  #     else
  #       false
  #     end
  #   end
  # end
  #
  # def duration_in_minutes
  #   if self.start_date.present? && self.end_date.present?
  #     ((end_date - start_date) / 1.minute).round
  #   else
  #     0
  #   end
  # end
  #
  # def duration_in_hours
  #   if self.start_date.present? && self.end_date.present?
  #     ((end_date - start_date) / 1.hour).round
  #   else
  #     0
  #   end
  # end
  #
  # def duration_in_days
  #   if self.start_date.present? && self.end_date.present?
  #     ((end_date - start_date) / 1.day).round
  #   else
  #     0
  #   end
  # end
  #
  # def public_duration_in_minutes
  #   if self.public_start_date.present? && self.public_end_date.present?
  #     ((public_end_date - public_start_date) / 1.minute).round
  #   else
  #     0
  #   end
  # end
  #
  # def public_duration_in_hours
  #   if self.public_start_date.present? && self.public_end_date.present?
  #     ((public_end_date - public_start_date) / 1.hour).round
  #   else
  #     0
  #   end
  # end
  #
  # def public_duration_in_days
  #   if self.public_start_date.present? && self.public_end_date.present?
  #     ((public_end_date - public_start_date) / 1.day).round
  #   else
  #     0
  #   end
  # end
  #
  # def has_date_info?
  #   self.start_date.present? && self.end_date.present? && self.public_start_date.present? && self.public_end_date.present? && self.number_of_days.present? && self.public_number_of_days.present?
  # end
  #
  # def generate_datestring(translation_key, public_dates: false, location_string: '')
  #   if self.has_date_info? && translation_key.is_a?(String)
  #     Time.use_zone(self.time_zone) do
  #       _start_date = public_dates ? self.public_start_date : self.start_date
  #       _end_date = public_dates ? self.public_end_date : self.end_date
  #       _number_of_days = public_dates ? self.public_number_of_days : self.number_of_days
  #
  #       if self.all_day_event?
  #         I18n.t(
  #           "#{translation_key}.date-only",
  #           count: _number_of_days,
  #           start_date: I18n.l(_start_date, format: :event_date),
  #           end_date: I18n.l(_end_date, format: :event_date),
  #           location: location_string
  #         ).html_safe
  #       else
  #         I18n.t(
  #           "#{translation_key}.with-times",
  #           count: _number_of_days,
  #           start_datetime: I18n.l(_start_date, format: :event_datetime),
  #           start_date: I18n.l(_start_date, format: :event_date),
  #           start_time: I18n.l(_start_date, format: :event_time),
  #           end_datetime: I18n.l(_end_date, format: :event_datetime),
  #           end_date: I18n.l(_end_date, format: :event_date),
  #           end_time: I18n.l(_end_date, format: :event_time),
  #           location: location_string
  #         ).html_safe
  #       end
  #     end
  #   end
  #
  # end

end

class Survey::Answer < ApplicationRecord
  include RankedModel
  ranks :sort_order, with_same: :survey_question_id

  #has_enumerated :answertype, :class_name => 'AnswerType'
  belongs_to :survey_question, class_name: 'Survey::Question', foreign_key: 'survey_question_id'

  # default_scope {order(['survey_answers.sort_order', :id])}

  # has_many  :excluded_items_survey_maps
  # has_many  :programme_items, :through => :excluded_items_survey_maps
  #
  # has_many  :excluded_periods_survey_maps, :dependent => :destroy
  # has_many  :excluded_periods, :through => :excluded_periods_survey_maps,
  #           :source => :period,
  #           :source_type => 'TimeSlot'

  # before_save :default_values
  # def default_values
  #   self.answertype ||= AnswerType[:Simple]
  # end

  #
  #
  #
#   def updateTimeConflicts
#     if (answertype == AnswerType['TimeConflict']) || (answertype == AnswerType['AvailableTime'])
#       numberOfDays = SiteConfig.first.number_of_days
#       nbrConflicts = excluded_periods.size
#
#       if (start_day > -1) && (start_day < numberOfDays) # the conflict is for a specific time
#         startTime, endTime = startAndDuration(start_day, start_time, duration)
#         excluded_periods.delete if (nbrConflicts > 1) # if there is > 1 already then clear it
#
#         if (nbrConflicts == 1) # if there is 1 then replace if necessary
#           if (excluded_periods[0].start != startTime) || (excluded_periods[0].end != endTime)
#             excluded_periods.delete
#             addExcludedPeriod(answer, startTime, endTime)
#             save
#           end
#         else
#           addExcludedPeriod(answer, startTime, endTime)
#           save
#         end
#       else # the conflict repeats for every day
#         replace = true
#         startTime, endTime = startAndDuration(0, start_time, duration)
#
#         if nbrConflicts > 1 # Since all the periods are the same we just need to look at the first one
#           replace =  (excluded_periods[0].start != startTime) || (excluded_periods[0].end != endTime)
#         end
#
#         if replace
#           excluded_periods.delete
#
#           numberOfDays.times {
#             addExcludedPeriod(answer, startTime, endTime)
#             startTime, endTime = (startTime + 1.day), (endTime + 1.day)
#           }
#           save
#         end
#       end
#     end
#   end
#
# private
#
#   def addExcludedPeriod(answer, excludedStart, excludedEnd)
#     excluded_periods.new( :start => excludedStart, :end => excludedEnd )
#   end
#
#   def startAndDuration(start_day, start_time, duration)
#     times = start_time.split(':') # hours and minutes
#     start = Time.zone.parse(SiteConfig.first.start_date.to_s).beginning_of_day + start_day.to_i.days + times[0].to_i.hours + times[1].to_i.minutes
#     [start, start + duration.minutes]
#   end

end

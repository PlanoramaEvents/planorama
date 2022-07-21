class PersonScheduleSnapshot < ApplicationRecord
  belongs_to :schedule_snapshot
  belongs_to :person
end

class SingleGlobalForPerson < ActiveModel::Validator
  def validate(record)
    if record.day == nil
      if SessionLimit.where({day: nil, person_id: record.person_id}).count > 1
        record.errors.add :day, "Can only have one global limit per person!"
      end
    end
  end
end

class SessionLimit < ApplicationRecord
  belongs_to  :person

  validates :person_id, presence: true
  # validates :max_sessions, presence: true
  validates_with SingleGlobalForPerson
end

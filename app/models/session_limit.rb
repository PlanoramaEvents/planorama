# == Schema Information
#
# Table name: session_limits
#
#  id           :uuid             not null, primary key
#  day          :date
#  lock_version :integer
#  max_sessions :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  person_id    :uuid
#
# Indexes
#
#  index_session_limits_on_person_id          (person_id)
#  index_session_limits_on_person_id_and_day  (person_id,day) UNIQUE
#
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

  has_paper_trail versions: { class_name: 'Audit::PersonVersion' }, ignore: [:updated_at, :created_at, :lock_version]

  validates :person_id, presence: true
  # validates :max_sessions, presence: true
  validates_with SingleGlobalForPerson
end

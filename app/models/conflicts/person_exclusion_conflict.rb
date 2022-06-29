class Conflicts::PersonExclusionConflict < ApplicationRecord
  self.table_name = :person_exclusion_conflicts
  self.primary_key = :id

  belongs_to :person
  belongs_to :exclusion
  belongs_to :session
  belongs_to :excluded_session, class_name: 'Session'

  def readonly?
    true
  end
end

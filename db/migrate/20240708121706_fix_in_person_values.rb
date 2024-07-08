class FixInPersonValues < ActiveRecord::Migration[6.1]
  def up
    # One off change to make site "in person" is "in_person"
    # use like just in case of case issues
    Person.where("attendance_type ilike 'in person'").update_all(attendance_type: 'in_person')
  end
end

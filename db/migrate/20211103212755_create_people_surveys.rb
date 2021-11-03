class CreatePeopleSurveys < ActiveRecord::Migration[6.0]
  def change
    create_table :people_surveys, id: false do |t|
      t.uuid :survey_id
      t.uuid :person_id
    end
    add_index :people_surveys, :survey_id
    add_index :people_surveys, :person_id
    add_index :people_surveys, [:survey_id, :person_id], unique: true
  end
end

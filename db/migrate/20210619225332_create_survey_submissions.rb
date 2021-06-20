class CreateSurveySubmissions < ActiveRecord::Migration[6.0]
  def change
    create_table :survey_submissions do |t|
      t.string :name
      t.references :survey, index: true, null: false, foreign_key: true
      t.references :person, index: true, null: false, foreign_key: true
      t.timestamps
    end
  end
end

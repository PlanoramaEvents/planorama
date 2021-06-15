class CreateSurveyPages < ActiveRecord::Migration[6.0]
  def change
    create_table :survey_pages do |t|
      t.string :title
      t.bigint :next_page_id
      t.integer :sort_order
      t.timestamps
    end
    add_reference :survey_pages, :survey, index: true, foreign_key: true
    add_reference :survey_questions, :survey_page, index: true, foreign_key: true
    remove_reference :survey_questions, :survey
  end
end

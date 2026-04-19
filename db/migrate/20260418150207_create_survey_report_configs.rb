class CreateSurveyReportConfigs < ActiveRecord::Migration[7.2]
  def change
    create_table :survey_report_configs, id: :uuid do |t|
      t.string :name, limit: 100
      t.text :description
      t.integer :sort_order
      # id of survey
      t.references :survey, null: false      
      # query: question_id, search criteria
      t.jsonb :query, null: false, default: {}
      # t.string :query, limit: 500
      # ids of questions to show
      t.uuid :question_ids, array: true      

      t.integer :lock_version
      t.timestamps
    end
  end
end

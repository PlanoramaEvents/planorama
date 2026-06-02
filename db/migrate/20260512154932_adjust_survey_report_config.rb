class AdjustSurveyReportConfig < ActiveRecord::Migration[7.2]
  def change
    remove_column :survey_report_configs, :question_ids, :uuid, array: true
    add_column :survey_report_configs, :questions, :jsonb, array: true
  end
end

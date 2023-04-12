class ChangeSurveyColumnName < ActiveRecord::Migration[6.1]
  def change
    rename_column :surveys, :anonymous, :unassigned
  end
end

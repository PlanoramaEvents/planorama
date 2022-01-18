class AddStateToSubmission < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      CREATE TYPE submission_state_enum AS ENUM ('draft', 'submitted');
    SQL
    add_column :survey_submissions, :submission_state, :submission_state_enum, default: 'draft'
    add_index :survey_submissions, :submission_state
  end

  def down
    remove_column :survey_submissions, :submission_state
    execute <<-SQL
      DROP TYPE submission_state_enum;
    SQL
  end
end

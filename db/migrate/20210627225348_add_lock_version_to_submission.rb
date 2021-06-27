class AddLockVersionToSubmission < ActiveRecord::Migration[6.0]
  def change
    add_column :survey_submissions, :lock_version, :integer, default: 0
  end
end

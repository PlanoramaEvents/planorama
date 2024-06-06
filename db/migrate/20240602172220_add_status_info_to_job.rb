class AddStatusInfoToJob < ActiveRecord::Migration[6.1]
  def change
    add_column :job_statuses, :result, :jsonb
  end
end

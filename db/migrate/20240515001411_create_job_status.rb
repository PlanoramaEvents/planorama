class CreateJobStatus < ActiveRecord::Migration[6.1]
  def change
    rename_table :publication_statuses, :job_statuses
    add_column :job_statuses, :type, :string

    reversible do |change|
      change.up do
        execute <<-SQL
          UPDATE job_statuses set type = 'PublicationStatus';
        SQL
      end
    end

  end
end

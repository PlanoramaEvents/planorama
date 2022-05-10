class ChangeReponseJson < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
          ALTER TABLE survey_responses ALTER COLUMN response SET DATA TYPE jsonb;
        SQL
      end
    end
  end
end

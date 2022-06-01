class AddMeasurementSystem < ActiveRecord::Migration[6.1]
  def change
    reversible do |change|
      change.down do
        execute <<-SQL
          DROP TYPE measurement_system_enum;
        SQL
      end
      change.up do
        execute <<-SQL
          CREATE TYPE measurement_system_enum AS ENUM ('Metric', 'Imperial');
        SQL
      end
    end
  end
end

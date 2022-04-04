class AddPersonFields < ActiveRecord::Migration[6.1]
  def change
    add_column :people, :attendance_type, :string, limit: 200, default: nil
    add_column :people, :twelve_hour, :boolean, default: true
    add_column :people, :timezone, :string, limit: 500, default: nil
  end
end

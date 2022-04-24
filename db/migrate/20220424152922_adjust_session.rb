class AdjustSession < ActiveRecord::Migration[6.1]
  def change
    add_column :sessions, :updated_by, :string
    add_column :sessions, :interest_opened_by, :string
    add_column :sessions, :interest_opened_at, :datetime
  end
end

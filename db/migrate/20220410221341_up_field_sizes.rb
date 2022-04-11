class UpFieldSizes < ActiveRecord::Migration[6.1]
  def change
    change_column :people, :pronouns, :string, limit: 400, default: nil
    change_column :people, :gender, :string, limit: 400, default: nil
    change_column :people, :ethnicity, :string, limit: 400, default: nil
  end
end

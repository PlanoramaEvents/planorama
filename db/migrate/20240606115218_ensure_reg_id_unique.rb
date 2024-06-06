class EnsureRegIdUnique < ActiveRecord::Migration[6.1]
  def change
    add_index :people, [:reg_id], unique: true, name: "idx_people_reg_id"
  end
end

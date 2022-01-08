class RemoveJtiColumns < ActiveRecord::Migration[6.0]
  def change
    remove_column :people, :jti, :string
  end
end

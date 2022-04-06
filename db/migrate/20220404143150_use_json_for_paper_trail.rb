class UseJsonForPaperTrail < ActiveRecord::Migration[6.1]
  def change
    rename_column :versions, :object, :object_old
    add_column :versions, :object, :json
  end
end

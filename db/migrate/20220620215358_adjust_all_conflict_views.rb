class AdjustAllConflictViews < ActiveRecord::Migration[6.1]
  # recreate all the views
  def up
    MigrationHelpers::PlanoViews.drop_views
    MigrationHelpers::PlanoViews.create_views
  end

  def down
    MigrationHelpers::PlanoViews.drop_views
  end
end

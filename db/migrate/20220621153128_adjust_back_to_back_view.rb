class AdjustBackToBackView < ActiveRecord::Migration[6.1]
  def up
    MigrationHelpers::PlanoViews.drop_views
    MigrationHelpers::PlanoViews.create_views
  end

  def down
    MigrationHelpers::PlanoViews.drop_views
  end
end

namespace :views do
  desc "Ensure that the views correct"
  task recreate: :environment do
    MigrationHelpers::PlanoViews.drop_views
    MigrationHelpers::PlanoViews.create_views
  end
end

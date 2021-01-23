class EnsureSortNoDefault < ActiveRecord::Migration[6.0]
  # ensure that the sort orders to not have a deg value for ranked
  def up
    # change_column_default( :programme_assignments, :sort_order, from: 0, to: false )
    # change_column_default( :published_programme_assignments, :sort_order, from: 0, to: false )

    execute %Q(
      alter table programme_assignments alter column sort_order drop default;
    )
    execute %Q(
      alter table published_programme_assignments alter column sort_order drop default;
    )
  end
end

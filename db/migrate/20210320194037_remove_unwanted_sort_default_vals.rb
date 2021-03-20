class RemoveUnwantedSortDefaultVals < ActiveRecord::Migration[6.0]
  def up
    execute %Q(
      alter table rooms alter column sort_order drop default;
    )

    execute %Q(
      alter table venues alter column sort_order drop default;
    )
  end
end

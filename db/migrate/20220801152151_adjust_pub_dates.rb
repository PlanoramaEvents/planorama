class AdjustPubDates < ActiveRecord::Migration[6.1]
  def change
    add_column :publication_dates, :new_sessions, :integer, default: 0
    add_column :publication_dates, :updated_sessions, :integer, default: 0
    add_column :publication_dates, :dropped_sessions, :integer, default: 0

    add_column :publication_dates, :new_assignments, :integer, default: 0
    add_column :publication_dates, :updated_assignments, :integer, default: 0
    add_column :publication_dates, :dropped_assignments, :integer, default: 0

    remove_column :publication_dates, :newitems, :integer
    remove_column :publication_dates, :modifieditems, :integer
    remove_column :publication_dates, :removeditems, :integer
  end
end

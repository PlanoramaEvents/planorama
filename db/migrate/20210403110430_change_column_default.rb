class ChangeColumnDefault < ActiveRecord::Migration[6.0]
  def up
    change_column_default :rooms, :sort_order, nil
    change_column_default :venues, :sort_order, nil
  end

  def down
    change_column_default :rooms, :sort_order, 0
    change_column_default :venues, :sort_order, 0
  end
end

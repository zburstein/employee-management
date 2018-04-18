class DropTip < ActiveRecord::Migration[5.1]
  def change
    remove_column :tip_pools, :tip_id
    drop_table :tips
  end
end

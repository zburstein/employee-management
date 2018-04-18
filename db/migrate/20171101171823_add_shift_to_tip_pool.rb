class AddShiftToTipPool < ActiveRecord::Migration[5.1]
  def change
    add_reference :tip_pools, :shift, foreign_key: true
  end
end

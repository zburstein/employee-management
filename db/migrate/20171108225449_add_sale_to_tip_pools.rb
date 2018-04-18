class AddSaleToTipPools < ActiveRecord::Migration[5.1]
  def change
    add_reference :tip_pools, :sale, foreign_key: true, index: true
  end
end

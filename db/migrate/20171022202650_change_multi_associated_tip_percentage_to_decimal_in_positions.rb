class ChangeMultiAssociatedTipPercentageToDecimalInPositions < ActiveRecord::Migration[5.1]
  def change
    remove_column :positions, :multi_associated_tip_percentage
    add_column :positions, :multi_associated_tip_percentage, :decimal
  end
end

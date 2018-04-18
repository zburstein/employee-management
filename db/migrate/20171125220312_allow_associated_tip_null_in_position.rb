class AllowAssociatedTipNullInPosition < ActiveRecord::Migration[5.1]
  def change
    change_column :positions, :solo_associated_tip_percentage, :decimal, :null => true
  end
end

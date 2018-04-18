class AddAssociateWithTipToPosition < ActiveRecord::Migration[5.1]
  def change
    add_column :positions, :associate_with_tip, :boolean
  end
end

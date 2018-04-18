class AddWageToShift < ActiveRecord::Migration[5.1]
  def change
    add_column :shifts, :wage, :decimal
  end
end

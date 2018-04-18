class AddPositionToShifts < ActiveRecord::Migration[5.1]
  def change
    remove_column :shifts, :role
    add_reference :shifts, :position, foreign_key: true, index: true
  end
end

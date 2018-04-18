class AddPositionToEmployees < ActiveRecord::Migration[5.1]
  def change
    remove_column :employees, :position
    add_reference :employees, :position, foreign_key: true, index: true
  end
end

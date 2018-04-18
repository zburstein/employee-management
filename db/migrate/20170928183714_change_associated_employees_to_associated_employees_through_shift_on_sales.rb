class ChangeAssociatedEmployeesToAssociatedEmployeesThroughShiftOnSales < ActiveRecord::Migration[5.1]
  def change
    remove_column :sales, :associated_employees
    add_column :sales, :associated_employees_through_shift_ids, :int, array: true, default: []
  end
end

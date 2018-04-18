class RemoveAssociatedEmployeesThroughShiftIdsFromSales < ActiveRecord::Migration[5.1]
  def change
    remove_column :sales, :associated_employees_through_shift_ids, :integer
  end
end

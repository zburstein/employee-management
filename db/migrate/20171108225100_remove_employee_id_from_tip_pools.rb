class RemoveEmployeeIdFromTipPools < ActiveRecord::Migration[5.1]
  def change
    remove_column :tip_pools, :employee_id, :integer
  end
end

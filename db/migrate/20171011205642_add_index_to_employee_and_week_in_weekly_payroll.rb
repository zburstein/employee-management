class AddIndexToEmployeeAndWeekInWeeklyPayroll < ActiveRecord::Migration[5.1]
  def change
    add_index :weekly_payrolls, [:employee_id, :week_id], unique: true
  end
end

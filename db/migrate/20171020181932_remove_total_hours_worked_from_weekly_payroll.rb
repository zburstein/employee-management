class RemoveTotalHoursWorkedFromWeeklyPayroll < ActiveRecord::Migration[5.1]
  def change
    remove_column :weekly_payrolls, :total_hours_worked, :decimal
  end
end

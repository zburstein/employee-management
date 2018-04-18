class ChangeDaysToHashInWeeklyPayroll < ActiveRecord::Migration[5.1]
  def change
    remove_column :weekly_payrolls, :monday_hours_worked
    remove_column :weekly_payrolls, :tuesday_hours_worked
    remove_column :weekly_payrolls, :wednesday_hours_worked
    remove_column :weekly_payrolls, :thursday_hours_worked
    remove_column :weekly_payrolls, :friday_hours_worked
    remove_column :weekly_payrolls, :saturday_hours_worked
    remove_column :weekly_payrolls, :sunday_hours_worked
    add_column :weekly_payrolls, :hours_worked_per_day, :text
  end
end

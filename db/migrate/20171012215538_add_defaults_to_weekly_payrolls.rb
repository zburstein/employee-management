class AddDefaultsToWeeklyPayrolls < ActiveRecord::Migration[5.1]
  def change
    change_column :weekly_payrolls, :total_wage, :decimal, :default => 0
    change_column :weekly_payrolls, :total_hours_worked, :decimal, :default => 0
    change_column :weekly_payrolls, :hours_worked_per_day, :text, :default => {sunday: 0, monday: 0, tuesday: 0, wednesday: 0, thursday: 0, friday: 0, saturday: 0}.to_yaml
  end
end

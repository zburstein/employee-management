class ChangeDefaultOfHoursWorkedPerDayInWeeklyPayrollToDecimal < ActiveRecord::Migration[5.1]
  def change
    default_hash = {}
    Date::DAYNAMES.each do |day|
      default_hash[day.downcase.to_sym] = BigDecimal.new(0)
    end
    change_column :weekly_payrolls, :hours_worked_per_day, :text, default: default_hash.to_yaml
  end
end

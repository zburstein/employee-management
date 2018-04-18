class AddDefaultToemployeesWorkedInWeek < ActiveRecord::Migration[5.1]
  def change
    change_column_default(:weeks, :employees_worked, [])  
  end
end

class RemoveEmployeesWorkedFromWeeks < ActiveRecord::Migration[5.1]
  def change
    remove_column :weeks, :employees_worked, :integer
  end
end

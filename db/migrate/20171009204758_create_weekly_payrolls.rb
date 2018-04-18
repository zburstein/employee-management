class CreateWeeklyPayrolls < ActiveRecord::Migration[5.1]
  def change
    create_table :weekly_payrolls do |t|
      t.belongs_to :employee, index: true
      t.belongs_to :week, index: true
      t.decimal :monday_hours_worked
      t.decimal :tuesday_hours_worked
      t.decimal :wednesday_hours_worked
      t.decimal :thursday_hours_worked
      t.decimal :friday_hours_worked
      t.decimal :saturday_hours_worked
      t.decimal :sunday_hours_worked
      t.decimal :total_hours_worked
      t.decimal :total_wage

      t.timestamps
    end
  end
end

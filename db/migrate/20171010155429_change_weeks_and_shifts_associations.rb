class ChangeWeeksAndShiftsAssociations < ActiveRecord::Migration[5.1]
  def change
    remove_reference :shifts, :week, index: true
    add_reference :shifts, :weekly_payroll, index: true
  end
end

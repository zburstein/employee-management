class AddWeekToShift < ActiveRecord::Migration[5.1]
  def change
    add_reference :shifts, :week, foreign_key: true, index: true
  end
end

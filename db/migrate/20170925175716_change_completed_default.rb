class ChangeCompletedDefault < ActiveRecord::Migration[5.1]
  def change
    change_column_default(:shifts, :completed, false)
  end
end

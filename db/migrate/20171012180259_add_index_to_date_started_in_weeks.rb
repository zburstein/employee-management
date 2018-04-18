class AddIndexToDateStartedInWeeks < ActiveRecord::Migration[5.1]
  def change
    add_index :weeks, :date_started, unique: true
  end
end

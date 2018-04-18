class CreateWeeks < ActiveRecord::Migration[5.1]
  def change
    create_table :weeks do |t|
      t.datetime :date_started
      t.integer :employees_worked, array: true

      t.timestamps
    end
  end
end

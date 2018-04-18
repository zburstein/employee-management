class CreateShifts < ActiveRecord::Migration[5.1]
  def change
    create_table :shifts do |t|
      t.belongs_to :employee, index: true
      t.datetime :finished_at
      t.decimal :wage_earned
      t.decimal :tip_earned
      t.string :role
      t.boolean :completed, index: true

      t.timestamps
    end
  end
end

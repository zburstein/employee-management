class ChangeWageScaleInShiftsAndEmployees < ActiveRecord::Migration[5.1]
  def change
    change_column :shifts, :wage_earned, :decimal, :precision => 10, :scale => 2
    change_column :shifts, :tip_earned, :decimal, :precision => 10, :scale => 2
    change_column :employees, :wage, :decimal, :precision => 10, :scale => 2
  end
end

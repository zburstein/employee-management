class SetTipEarnedDefaultInShifts < ActiveRecord::Migration[5.1]
  def change
    change_column :shifts, :tip_earned, :decimal, :default => 0
  end
end

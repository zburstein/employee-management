class CreatePositions < ActiveRecord::Migration[5.1]
  def change
    create_table :positions do |t|
      t.string :name, null: false
      t.decimal :solo_associated_tip_percentage, null: false
      t.string :multi_associated_tip_percentage, null: false
      t.string :location
      t.decimal :starting_wage

      t.timestamps
    end
  end
end

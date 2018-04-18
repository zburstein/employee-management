class CreateTipPools < ActiveRecord::Migration[5.1]
  def change
    create_table :tip_pools do |t|
      t.references :employee, foreign_key: true, index: true
      t.references :tip, foreign_key: true, index: true
      t.decimal :amount_for_employee
      t.decimal :percentage_of_total
      t.boolean :main_employee

      t.timestamps
    end
  end
end

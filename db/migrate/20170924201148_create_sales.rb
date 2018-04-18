class CreateSales < ActiveRecord::Migration[5.1]
  def change
    create_table :sales do |t|
      t.belongs_to :shift, index: true
      t.decimal :price
      t.decimal :tip
      t.string :method
      t.text :associated_employees, array: true, default: []


      t.timestamps
    end
  end
end

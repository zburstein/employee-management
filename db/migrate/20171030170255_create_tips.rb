class CreateTips < ActiveRecord::Migration[5.1]
  def change
    create_table :tips do |t|
      t.references :sale, foreign_key: true, index: true
      t.decimal :amount

      t.timestamps
    end
  end
end
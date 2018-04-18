class ChangeMethodToMethodOfPayment < ActiveRecord::Migration[5.1]
  def change
    rename_column :sales, :method, :method_of_payment
  end
end

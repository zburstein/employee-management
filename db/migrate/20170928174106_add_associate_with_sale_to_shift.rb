class AddAssociateWithSaleToShift < ActiveRecord::Migration[5.1]
  #used to check who should be added to associated sale
  def change
    add_column :shifts, :associate_with_sale, :boolean
  end
end

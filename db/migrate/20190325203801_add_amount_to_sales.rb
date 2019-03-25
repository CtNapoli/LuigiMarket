class AddAmountToSales < ActiveRecord::Migration[5.1]
  def change
    add_column :sales, :amount, :integer
  end
end

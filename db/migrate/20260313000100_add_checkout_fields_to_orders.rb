class AddCheckoutFieldsToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :subtotal, :decimal, precision: 10, scale: 2
    add_column :orders, :shipping_total, :decimal, precision: 10, scale: 2
    add_column :orders, :bulky_total, :decimal, precision: 10, scale: 2
    add_column :orders, :tax_total, :decimal, precision: 10, scale: 2
  end
end

class AddPaypalFieldsToOrders < ActiveRecord::Migration[8.1]
  def change
    add_column :orders, :paypal_order_id, :string
    add_column :orders, :paypal_capture_id, :string
    add_column :orders, :payment_status, :string
  end
end

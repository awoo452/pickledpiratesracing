class RemoveActiveFromVendorProducts < ActiveRecord::Migration[8.1]
  def change
    remove_column :vendor_products, :active, :boolean
  end
end

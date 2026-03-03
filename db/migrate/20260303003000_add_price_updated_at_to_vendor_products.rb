class AddPriceUpdatedAtToVendorProducts < ActiveRecord::Migration[8.1]
  def change
    add_column :vendor_products, :price_updated_at, :datetime
  end
end

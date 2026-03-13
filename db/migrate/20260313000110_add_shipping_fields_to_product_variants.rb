class AddShippingFieldsToProductVariants < ActiveRecord::Migration[8.0]
  def change
    add_column :product_variants, :weight_ounces, :decimal, precision: 8, scale: 2
    add_column :product_variants, :bulky, :boolean, default: false, null: false
  end
end

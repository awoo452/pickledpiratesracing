class CreateVendorProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :vendor_products do |t|
      t.references :vendor, null: false, foreign_key: true
      t.references :product_variant, null: false, foreign_key: true
      t.string :vendor_sku
      t.decimal :unit_cost, precision: 8, scale: 2
      t.decimal :msrp, precision: 8, scale: 2
      t.integer :min_order_quantity
      t.integer :lead_time_days
      t.boolean :active, default: true, null: false
      t.text :notes

      t.timestamps
    end

    add_index :vendor_products, [ :vendor_id, :product_variant_id ], unique: true
  end
end

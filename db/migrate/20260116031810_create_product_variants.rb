class CreateProductVariants < ActiveRecord::Migration[7.1]
  def change
    create_table :product_variants do |t|
      t.references :product, null: false, foreign_key: true
      t.string :name, null: false
      t.decimal :price_override, precision: 8, scale: 2
      t.integer :stock, default: 0
      t.boolean :active, default: true

      t.timestamps
    end
  end
end

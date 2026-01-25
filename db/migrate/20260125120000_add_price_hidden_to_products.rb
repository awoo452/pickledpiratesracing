class AddPriceHiddenToProducts < ActiveRecord::Migration[7.1]
  def up
    add_column :products, :price_hidden, :boolean, default: true, null: false
    Product.reset_column_information
    Product.update_all(price_hidden: true)
  end

  def down
    remove_column :products, :price_hidden
  end
end

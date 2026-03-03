class AddMarginFieldsToProducts < ActiveRecord::Migration[8.1]
  def change
    add_column :products, :margin_percent, :decimal, precision: 5, scale: 2
    add_column :products, :handling_fee, :decimal, precision: 8, scale: 2
  end
end

class AddImageKeyToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :image_key, :string
  end
end

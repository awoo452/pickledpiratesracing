class AddImageToEvents < ActiveRecord::Migration[8.1]
  def change
    add_column :events, :image_key, :string
  end
end

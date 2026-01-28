class AddAltImageKeyToEvents < ActiveRecord::Migration[8.1]
  def change
    add_column :events, :image_alt_key, :string
  end
end

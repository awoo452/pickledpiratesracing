class AddEraToParts < ActiveRecord::Migration[8.1]
  def change
    add_column :parts, :era, :string, null: false, default: "current"
  end
end

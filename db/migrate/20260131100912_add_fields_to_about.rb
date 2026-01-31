class AddFieldsToAbout < ActiveRecord::Migration[8.1]
  def change
    add_column :about, :eyebrow, :string
    add_column :about, :lede, :string
    add_column :about, :image_key, :string
  end
end

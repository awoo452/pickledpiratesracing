class AddProfileImageKeyToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :profile_image_key, :string
  end
end

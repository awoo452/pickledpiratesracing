class AddUserToRewards < ActiveRecord::Migration[8.0]
  def change
    add_reference :rewards, :user, null: false, foreign_key: true
  end
end

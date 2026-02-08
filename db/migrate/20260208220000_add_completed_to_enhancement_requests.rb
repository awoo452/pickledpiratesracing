class AddCompletedToEnhancementRequests < ActiveRecord::Migration[8.1]
  def up
    add_column :enhancement_requests, :completed, :boolean, default: false, null: false
  end

  def down
    remove_column :enhancement_requests, :completed
  end
end

class CreateEnhancementRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :enhancement_requests do |t|
      t.string :email
      t.text :message

      t.timestamps
    end
  end
end

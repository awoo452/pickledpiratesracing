class CreateParts < ActiveRecord::Migration[8.1]
  def change
    create_table :parts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :part, null: false
      t.text :description, null: false
      t.decimal :price, null: false, precision: 10, scale: 2
      t.text :contact_info, null: false

      t.timestamps
    end
  end
end

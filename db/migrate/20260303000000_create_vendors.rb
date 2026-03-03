class CreateVendors < ActiveRecord::Migration[8.1]
  def change
    create_table :vendors do |t|
      t.string :name, null: false
      t.string :contact_name
      t.string :email
      t.string :phone
      t.string :website
      t.text :notes
      t.boolean :active, default: true, null: false

      t.timestamps
    end
  end
end

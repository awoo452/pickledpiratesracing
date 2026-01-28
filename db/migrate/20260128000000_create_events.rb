class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.date :event_date, null: false
      t.string :location
      t.text :description
      t.string :link

      t.timestamps
    end
  end
end

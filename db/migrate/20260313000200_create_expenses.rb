class CreateExpenses < ActiveRecord::Migration[8.0]
  def change
    create_table :expenses do |t|
      t.string :description, null: false
      t.string :owed_to, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.date :spent_on, null: false
      t.boolean :reimbursed, null: false, default: false
      t.text :notes
      t.timestamps
    end

    add_index :expenses, :spent_on
    add_index :expenses, :owed_to
    add_index :expenses, :reimbursed
  end
end

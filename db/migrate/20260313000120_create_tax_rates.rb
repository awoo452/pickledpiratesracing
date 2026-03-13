class CreateTaxRates < ActiveRecord::Migration[8.0]
  def change
    create_table :tax_rates do |t|
      t.string :state, null: false
      t.decimal :rate, precision: 6, scale: 5, null: false, default: 0
      t.timestamps
    end

    add_index :tax_rates, :state, unique: true
  end
end

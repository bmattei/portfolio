class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.decimal :price, precision: 16, scale: 4
      t.integer :ticker_id
      t.timestamps null: false
    end
  end
end

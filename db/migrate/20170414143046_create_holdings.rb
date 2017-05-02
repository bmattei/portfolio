class CreateHoldings < ActiveRecord::Migration
  def change
    create_table :holdings do |t|
      t.integer :account_id
      t.integer :ticker_id
      t.decimal :shares, precision: 16, scale: 4
      t.date    :purchase_date
      t.decimal :purchase_price, precision: 16, scale: 4
      t.timestamps null: false
    end
  end
end

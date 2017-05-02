class CreateTickers < ActiveRecord::Migration
  def change
    create_table :tickers do |t|
      t.string :name
      t.string :symbol, limit: 8
      t.timestamps null: false
    end
  end
end

class CreateCategoryTickers < ActiveRecord::Migration
  def change
    create_table :category_tickers do |t|
      t.integer :category_id
      t.integer :ticker_id
      t.decimal :split, precision: 6, scale: 5
      t.timestamps null: false
    end
  end
end

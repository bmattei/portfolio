class CreateGroupingsTickers < ActiveRecord::Migration[5.1]
  def change
    create_table :groupings_tickers do |t|
      t.integer :grouping_id
      t.integer :ticker_id
      t.decimal :split, precision: 6, scale: 5
      t.timestamps null: false
    end
  end
end

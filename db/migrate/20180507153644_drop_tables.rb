class DropTables < ActiveRecord::Migration[5.1]
  def up
    drop_table :groupings
    drop_table :groupings_tickers
    drop_table :category_tickers
    drop_table :categories
  end
end

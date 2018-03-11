class AddToTickers < ActiveRecord::Migration[5.0]
  def change
    add_column :tickers, :maturity, :decimal, precision: 5, scale: 2
    add_column :tickers, :duration, :decimal, precision: 5, scale: 2
    add_column :tickers, :expenses, :decimal, precision: 5, scale: 2
    add_column :tickers, :quality, :string
    add_column :tickers, :idx_name, :string
    add_column :tickers, :group, :string
    
  end
end

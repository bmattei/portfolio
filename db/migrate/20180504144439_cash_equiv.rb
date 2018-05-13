class CashEquiv < ActiveRecord::Migration[5.1]
  def change
    add_column :tickers, :bs_cash, :decimal, precision: 6, scale: 5
  end
end

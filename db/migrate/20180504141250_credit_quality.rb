class CreditQuality < ActiveRecord::Migration[5.1]
  def change
    add_column :tickers, :cq_aaa, :decimal, precision: 6, scale: 5
    add_column :tickers, :cq_aa, :decimal, precision: 6, scale: 5
    add_column :tickers, :cq_a, :decimal, precision: 6, scale: 5
    add_column :tickers, :cq_bbb, :decimal, precision: 6, scale: 5
    add_column :tickers, :cq_bb, :decimal, precision: 6, scale: 5
    add_column :tickers, :cq_b, :decimal, precision: 6, scale: 5
    add_column :tickers, :cq_below_b, :decimal, precision: 6, scale: 5
    add_column :tickers, :cq_not_rated, :decimal, precision: 6, scale: 5
  end
end

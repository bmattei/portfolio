class UpdateTicker < ActiveRecord::Migration[5.1]
  def change
    add_column :tickers, :category, :string
  end
end

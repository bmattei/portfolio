class AddDescToTicker < ActiveRecord::Migration[5.0]
  def change
    add_column :tickers, :description, :string
  end
end

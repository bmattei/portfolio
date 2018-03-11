class AddDescToTickers < ActiveRecord::Migration[5.0]
  def change
    add_column :tickers, :description, :string
    add_column :tickers, :index, :string
  end
end

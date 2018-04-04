class ModifyTicker < ActiveRecord::Migration[5.1]
  def change
    add_column :tickers, :data_link, :string
    add_column :tickers, :stype, :integer
  end
end

class AddIndexToHoldings < ActiveRecord::Migration[5.2]
  def change
    add_index :holdings, [:ticker_id, :account_id], unique: true
  end
end

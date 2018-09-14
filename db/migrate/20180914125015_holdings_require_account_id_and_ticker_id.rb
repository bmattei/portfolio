class HoldingsRequireAccountIdAndTickerId < ActiveRecord::Migration[5.2]
  def change
    change_column :holdings, :account_id, :integer,  null: false
    change_column :holdings, :ticker_id, :integer, null: false
  end
end

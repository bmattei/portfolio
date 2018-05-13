class ChangeTickerGroupNames < ActiveRecord::Migration[5.1]
  def change
    rename_column :tickers, :aa_bonds, :aa_bond
    rename_column :tickers, :ss_communications, :ss_communications_services
  end
end

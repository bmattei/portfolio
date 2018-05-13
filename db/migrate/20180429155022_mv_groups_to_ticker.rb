class MvGroupsToTicker < ActiveRecord::Migration[5.1]
  def change
    add_column :tickers, :aa_us_stock, :decimal, precision: 6, scale: 5
    add_column :tickers, :aa_non_us_stock, :decimal, precision: 6, scale: 5
    add_column :tickers, :aa_bonds, :decimal, precision: 6, scale: 5
    add_column :tickers, :aa_cash, :decimal, precision: 6, scale: 5
    add_column :tickers, :aa_other, :decimal, precision: 6, scale: 5

    add_column :tickers, :cap_giant, :decimal, precision: 6, scale: 5
    add_column :tickers, :cap_large, :decimal, precision: 6, scale: 5
    add_column :tickers, :cap_medium, :decimal, precision: 6, scale: 5
    add_column :tickers, :cap_small, :decimal, precision: 6, scale: 5
    add_column :tickers, :cap_micro, :decimal, precision: 6, scale: 5

    add_column :tickers, :bs_government, :decimal, precision: 6, scale: 5
    add_column :tickers, :bs_corporate, :decimal, precision: 6, scale: 5
    add_column :tickers, :bs_securitized, :decimal, precision: 6, scale: 5
    add_column :tickers, :bs_municipal, :decimal, precision: 6, scale: 5
    add_column :tickers, :bs_other, :decimal, precision: 6, scale: 5
    add_column :tickers, :gov_tips, :decimal, precision: 6, scale: 5
    add_column :tickers, :gov_nominal, :decimal, precision: 6, scale: 5
    
    add_column :tickers, :ss_basic_material, :decimal, precision: 6, scale: 5
    add_column :tickers, :ss_consumer_cyclical, :decimal, precision: 6, scale: 5
    add_column :tickers, :ss_financial_services, :decimal, precision: 6, scale: 5
    add_column :tickers, :ss_realestate, :decimal, precision: 6, scale: 5
    add_column :tickers, :ss_communications, :decimal, precision: 6, scale: 5
    add_column :tickers, :ss_energy, :decimal, precision: 6, scale: 5
    add_column :tickers, :ss_industrials, :decimal, precision: 6, scale: 5
    add_column :tickers, :ss_technology, :decimal, precision: 6, scale: 5
    add_column :tickers, :ss_consumer_defensive, :decimal, precision: 6, scale: 5
    add_column :tickers, :ss_healthcare, :decimal, precision: 6, scale: 5
    add_column :tickers, :ss_utilities, :decimal, precision: 6, scale: 5

    add_column :tickers, :mr_americas, :decimal, precision: 6, scale: 5
    add_column :tickers, :mr_greater_europe, :decimal, precision: 6, scale: 5
    add_column :tickers, :mr_greater_asia, :decimal, precision: 6, scale: 5

    add_column :tickers, :mc_developed, :decimal, precision: 6, scale: 5
    add_column :tickers, :mc_emerging, :decimal, precision: 6, scale: 5


    
  end
end

require 'test_helper'

class HoldingTest < ActiveSupport::TestCase
  test "Holding must have ticker" do
     holding = Holding.new
     holding.account = Account.first
     assert_not holding.save, "Saved without a Ticker"
   end
   test "Holding must have account" do
     holding = Holding.new
     holding.ticker = Ticker.first
     assert_not holding.save, "saved without an Account"
   end
   test "Holding don't save holding with 0 shares" do
     account = accounts(:lauraTaxable)
     num_holdings = account.holdings.count
     total_num_holdings = holdings.count
     ticker  = tickers(:VNQ)
     holding = Holding.create(account: account,
                        ticker: ticker,
                        shares: 100)
     account.reload
     assert_equal  num_holdings + 1,  account.holdings.count
     assert_equal  total_num_holdings + 1, Holding.all.count
     holding.shares = 0
     holding.save
     account.reload
     assert num_holdings, account.holdings.count
     assert total_num_holdings,Holding.all.count
   end
     
     
                    
   
   
end

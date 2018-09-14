require 'test_helper'

class HoldingTest < ActiveSupport::TestCase
  # We have a validates uniqueness of ticker_id - so this will not throw an error but will not save
  test "Holding must have ticker" do
     holding = Holding.new
     holding.account = Account.first
     before_count = Holding.all.count
     assert_not holding.save, "Saved without a Ticker"
     after_count = Holding.all.count
     assert_equal before_count, after_count,  "Holding should not have been added"
   end

  # We had to remove the validate_uniqueness so adding nested holding while adding an
  # account worked - but we require the account_id in the DB so this will raise and error
  #
  test "Holding must have account" do
     holding = Holding.new
     holding.ticker = Ticker.first
     before_count = Holding.all.count
     assert_raises(ActiveRecord::StatementInvalid) {holding.save}
     after_count = Holding.all.count
     assert_equal before_count, after_count,  "Holding should not have been added"
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

  test 'Holdings Value' do
    holding = holdings(:EFVLaura)
    value = holding.shares * holding.price
    assert_equal value.to_f, holding.value
  end

   
   
end

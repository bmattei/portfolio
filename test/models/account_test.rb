require 'test_helper'

class AccountTest < ActiveSupport::TestCase

  test "account has correct total value" do
    account = accounts(:lauraTaxable)
    total_value = account.holdings.inject(0)  {|sum, n| sum + n.value}  + account.cash
    assert_equal total_value.to_f, account.total_value.to_f, "Total value calculated correctly"
  end
    
  test "account total_value get updated correct when holding is added" do
    account = accounts(:lauraTaxable)
    ticker = Ticker.where(symbol: :VWO).first
    total_value_before = account.holdings.inject(0)  {|sum, n| sum + n.value}  + account.cash
    num_shares = 111
    account.holdings.create(ticker_id: ticker.id, shares: num_shares,
                           purchase_price: ticker.last_price)
    total_value_now = total_value_before + num_shares * ticker.last_price
    assert_equal total_value_now.to_f, account.total_value.to_f
  end

  test "account has correct holdings value" do
    account = accounts(:lauraTaxable)
    account.update_values # Fixture don't trigger callback that does calculations
    holdings_value = account.holdings.inject(0)  {|sum, n| sum + n.value}
    assert_equal holdings_value.to_f, account.holdings_value.to_f
  end

end

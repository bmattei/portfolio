require 'test_helper'

class AccountTest < ActiveSupport::TestCase

  test "account has correct total value" do
    account = accounts(:lauraTaxable)
    total_value = account.holdings.inject(0)  {|sum, n| sum + n.value}  + account.cash
    assert_equal total_value.to_f, account.total_value.to_f, "Total value calculated correctly"
  end
  
  test "account total_value get updated correct when holding is added" do
    account = accounts(:lauraTaxable)
    ticker = Ticker.where(symbol: :AFL).first
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

  test "account has correct holding value when holding is deleted" do
    account = accounts(:lauraTaxable)
    value_before_delete = account.total_value
    expected_value_after = account.total_value - account.holdings.first.value
    account.holdings.first.destroy
    account.reload
    assert_equal expected_value_after, account.total_value
  end

  test "account has correct holding value when cash is changed" do
    account = accounts(:lauraTaxable)
    value_before = account.total_value
    account.cash = account.cash + 10
    account.save
    assert_equal value_before + 10, account.total_value
  end
  test "segment value" do
    account = accounts(:lauraTaxable)
    value_us_stocks = account.holdings.inject(0) {|sum, n| sum + n.us_stock_amount }
    assert_equal value_us_stocks, account.segment_amount(:us_stock)
  end

end


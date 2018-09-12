require 'test_helper'

class TickerTest < ActiveSupport::TestCase
  def setup
    @ticker = tickers(:VWO)
  end
  test "Get last_ticker price" do
    price = prices(:VWO_1)
    assert_equal price.price, @ticker.last_price, "Wrong Price expected: #{price.price} got: #{@ticker.last_price}"
    assert_equal price.updated_at, @ticker.last_price_date, "Wrong Price Date"
  end

  test "Get Last price for ticker that has no price" do
    ticker = tickers(:IBM)
    assert_nil ticker.last_price
    assert_nil ticker.last_price_date
  end

  test "Retrieve Prices for ticker that has NO Prices " do
    ticker = tickers(:IBM)
    assert_nil ticker.last_price
    assert_nil ticker.last_price_date
    ticker.retrieve_price
    assert ticker.last_price, "Price should not be nil"
    assert ticker.last_price > 0
    assert_not_nil ticker.last_price_date
  end

  test "Get Prices for all owned tickers" do
    date_time = DateTime.now
    sleep 1
    old_info = {}
    Ticker.all.each do |ticker|
      old_info[ticker.symbol] = ticker.last_price
    end
    Ticker.retrieve_all_prices
    # Test that held tickers prices were updated
    Holding.all.each do |h|
      assert h.ticker.last_price_date
      # This assert won't work if markets are closed
      # assert h.ticker.last_price_date > date_time

      # All prices in Fixtures are not realistic so
      # new prices should never match
      assert_not_equal h.ticker.last_price.to_f, old_info[h.symbol].to_f
    end
    # Test that unheld ticker prces were not updated
    held_tickers = Holding.all.each.collect { |x| x.ticker }.uniq
    unheld_tickers = Ticker.all - held_tickers
    unheld_tickers.each do |ticker|
      if !old_info[ticker.symbol]
        assert_nil ticker.last_price
      else
        assert_equal  old_info[ticker.symbol], ticker.last_price
      end
    end
  end

  test "Get Price on Date for date that we have price info" do
    old_price = prices(:VWO_2)
    price_on_date = @ticker.price_on(old_price.updated_at)
    assert_equal old_price.price.to_f, price_on_date.to_f
    assert_not_equal @ticker.last_price.to_f, price_on_date.to_f
  end
  
end


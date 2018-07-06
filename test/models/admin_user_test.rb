require 'test_helper'

class AdminUserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "test admin_user new_capture returns new prices" do
    user = admin_users(:laura)
    # set price to something it will never be
    fake_price = 0.01
    user.holdings.each do |h|
      price = h.ticker.prices.last
      price.price = fake_price
      price.save
    end
    price_info = user.holdings.collect {|x| OpenStruct.new(symbol: x.symbol, price: x.price, price_date: x.price_date) }
    sleep(2) # to insure dates times change.
    user.new_capture
    
    user.holdings.each_with_index do |x, i|
      pp x.ticker.prices.last.price.to_f
      assert x.price > fake_price
      assert x.price_date > price_info[i].price_date, "new: #{x.price_date} old: #{price_info[i].price_date}"
    end
  end
end

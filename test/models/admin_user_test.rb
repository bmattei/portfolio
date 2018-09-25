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
      assert x.price > fake_price
      assert x.price_date > price_info[i].price_date, "new: #{x.price_date} old: #{price_info[i].price_date}"
    end
  end

  test "AdminUser Summary Data" do
    user  = admin_users(:laura)
    calc_summary = {}
    user.holdings.each do |h|
      if !calc_summary[h.symbol]
        calc_summary[h.symbol] =
          {
            symbol: h.symbol,
            shares: h.shares,
            price: h.price,
            value: h.value,
            description: h.description,
            expenses: h.expenses,
            us_equity: h.ticker.aa_us_stock,
            foreign_equity: h.ticker.aa_non_us_stock.to_f,
            bond: h.ticker.aa_bond.to_f,
            other: h.ticker.aa_other.to_f,
            cash: h.ticker.aa_cash.to_f
          }
      else
        calc_summary[h.symbol][:shares] += h.shares
        calc_summary[h.symbol][:value] += h.value
      end
    end
    total_value = user.total_value
    calc_summary.each do |k,v|
      v[:percent] = (v[:value]/total_value).to_f
    end
    total_cash = user.accounts.inject(0) {|sum, a| sum + a.cash }.to_f
    calc_summary["CASH"] = { symbol: 'CASH',
                            shares: 0,
                            price: 0,
                            value: total_cash,
                            percent: total_cash > 0 ? (total_cash/total_value) :  0,
                            cash: 1
                          }
    summary_info = user.summary_info
    last_value = 100000000
    summary_info.each do |x|
      expected = calc_summary[x.symbol]
      assert_equal expected[:shares].to_f, x.shares.to_f, "#{x.symbol} Shares"
      assert_equal expected[:expenses].to_f, x.expenses.to_f, "#{x.symbol} Expenses"
      assert_equal expected[:price].to_f, x.price.to_f, "#{x.symbol} Price"
      assert_equal expected[:value].to_f, x.value.to_f, "#{x.symbol} Value"
      assert_equal expected[:us_equity].to_f, x.us_equity.to_f, "#{x.symbol} Us_Equity"
      assert_equal expected[:foreign_equity].to_f, x.foreign_equity.to_f, "#{x.symbol} Foriegn Equity"
      assert_equal expected[:bond].to_f, x.bond.to_f, "#{x.symbol} Bond"
      assert_equal expected[:cash].to_f, x.cash.to_f, "#{x.symbol} Cash"
      assert_equal expected[:percent].to_f, x.percent.to_f, "#{x.symbol} Percent"
      assert_equal expected[:description].to_s, x.description.to_s, "#{x.symbol} Description"
    end
  end

end

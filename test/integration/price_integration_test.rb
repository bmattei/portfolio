require 'test_helper'
class PriceIntegrationTest < ActionDispatch::IntegrationTest
  def setup
    @user = admin_users(:laura)
    params = {"admin_user"=>  { 'email' =>  @user.email,
                                "password" =>  'laura_pw'
                              }
             }
    
    post '/admin/login', params: params
    assert_equal 302, status

    follow_redirect!
    assert_equal 200, status
  end

  test "Price Show Returns Success" do
    @user.tickers.each do |ticker|
      price = ticker.prices.first
      get admin_price_url(price)
      assert_response :success
    end
  end

  test " index page title" do
    get admin_prices_url
    assert_response :success
    assert_select("#title_bar") do
      assert_select "h2", "Prices", "Expect title to be Prices"
    end
  end

  test "Price Table has correct headings" do
    get admin_prices_url
    assert_response :success
    expected_headers = ["Ticker", "Price", "Price Date"]
    assert_select "thead:nth-child(1)" do |element|
      assert_equal expected_headers, element[0].css('th')[0..-2].collect {|x| x.text}
    end
  end

  test "Prices Table has correct data" do
    get admin_prices_url
    assert_response :success
    ftr = ActionController::Base.helpers
    assert_select "table:nth-child(1) > tbody > tr" do |rows|
      expected_data = Price.all.order(price_date: :desc).collect do |p|
        [
          p.symbol,
          ftr.number_to_currency(p.price),          
          p.price_date.strftime('%B %d, %Y'),
        ]
      end
      rows.each_with_index do |r, i|
        columns = r.css('td')[0..-2].collect { |x| x.text }
        assert_equal expected_data[i], columns, "Index table row is incorrect"
      end
    end
  end




end

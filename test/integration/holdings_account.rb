require 'test_helper'

class HoldingsAccountTest < ActionDispatch::IntegrationTest
  def setup
    user_laura = admin_users(:laura)
    params = {"admin_user"=>  { 'email' =>  user_laura.email,
                                "password" =>  'laura_pw'
                              }
             }
    post '/admin/login', params: params
    pp response.body
    assert_equal 302, status
    follow_redirect!
    assert_equal 200, status
  end

  # "holding"=>{"account_id"=>"38", "ticker_id"=>"989003874", "shares"=>"100", "purchase_price"=>"180", "purchase_date"=>"2018-06-27"}
  def test_add_holding
    account = accounts(:lauraTaxable)
    assert account
    
    before_total_value = account.total_value
    before_num_holdings = account.holdings.count


    ticker = Ticker.where(symbol: 'SCHP').first
    assert ticker

    # get "/admin/holdings/new"
    # assert_response :success

    num_shares = 100
    purchase_price = 78.89
    create_msg = { 'holding' =>  {'account_id' => account.id.to_s,
                              'ticker_id' => ticker.id.to_s,
                              'purchase_price' => purchase_price.to_s,
                              'shares' =>  num_shares.to_s,
                              'purchase_date' => Date.today.to_s
                             }
                 }
    post '/admin/holdings', params: create_msg
    assert_response :redirect
    follow_redirect!
    assert_response :success
    title =  Nokogiri::HTML::Document.parse(response.body).title
    assert_match "Holding", title, "Title is incorrect we are on the wrong page: #{title}"
    account.reload
    
    assert_equal (before_num_holdings + 1).to_f, account.holdings.count.to_f, "holdings count not incremented"
    total_value = account.holdings.inject(0) {|sum, x| sum + x.value } + account.cash
    assert_equal total_value.to_f, account.total_value.to_f, "Total Value not updated correctly"

  end

  def test_total_value_updates_when_prices_update
    account = accounts(:lauraTaxable)
    holding = account.holdings.first
    price = holding.prices.order(:price_date).last
    ticker_id = holding.ticker.id
    previous_total_value = account.total_value
    price_change = 100
    new_price = price.price + price_change
    Price.create(ticker_id: ticker_id,
                 price_date: Date.today,
                 price: price.price + price_change)
    change_in_value = price_change * holding.shares
    expected_total_value = previous_total_value + change_in_value
    assert_equal expected_total_value.to_f, account.total_value.to_f, "expected value to change by #{change_in_value}"
    

  end



end

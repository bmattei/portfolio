require 'test_helper'

class HoldingAccountIntegrationTest < ActionDispatch::IntegrationTest
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

  test "Holding Show Returns Success" do
    @user.holdings.each do |h|
      get admin_holding_url(h)
      assert_response :success
    end
  end

  test "Holdings show, details table correct headers" do
    holding= @user.holdings.first
    assert holding
    get admin_holding_url(holding)
    assert_response :success
    expected_headers = ["Account", "Name", "Symbol", "Shares", "Purchase Price", "Price", "Value"]
    headers = css_select('table > tr > th').collect {|x| x.text}
    assert_equal expected_headers, headers
  end
  
  test "Holdings show, details table correct data" do
    holding= @user.holdings.first
    assert holding
    get admin_holding_url(holding)
    assert_response :success
    ftr = ActionController::Base.helpers
    headers = ["Account", "Name", "Symbol", "Shares", "Purchase Price", "Price", "Value"]
    expected_data = [holding.account_name,
                     holding.name || 'empty',
                     holding.symbol,
                     "%.2f" % holding.shares,
                     ftr.number_to_currency(holding.purchase_price),
                     ftr.number_to_currency(holding.price),
                     ftr.number_to_currency(holding.value)
                    ]
    data = css_select('table > tr > td').collect {|x| x.text}
    expected_data.each_with_index do |expected, i|
      assert_equal expected, data[i], "\nHolding #{headers[i]}\n"
    end
  end

  test "Holdings show, Price Table headers" do
    holding= @user.holdings.first
    assert holding
    get admin_holding_url(holding)
    assert_response :success
    expected_headers = ["Price", "Price Date"]
    headers = css_select('table > thead> tr > th').collect {|x| x.text}
    assert_equal expected_headers, headers
  end

  test "Holdings show, Price Table Data" do
    holding= holdings(:VWOLauraTaxable)
    assert holding
    get admin_holding_url(holding)
    assert_response :success
    ftr = ActionController::Base.helpers
    prices = holding.prices.order(price_date: :desc)
    i = 0
    assert_select("table > tbody > tr") do |rows|
      rows.each do |r|
        expected_data =
          [
            ftr.number_to_currency(prices[i].price),
            prices[i].price_date.strftime('%B %d, %Y')
          ]
        i = i + 1
        data = r.css('td').collect {|x| x.text }
        assert_equal expected_data, data
        
      end
    end
  end

  test "Holding Page Title" do
    get admin_holdings_url
    assert_response :success
    assert_select("#title_bar") do
      assert_select "h2", "Holdings", "Expect title to be Holdings"
    end
  end

  test "Holding Table has correct headings" do
    get admin_holdings_url
    assert_response :success
    expected_headers = ["Account", "Brokerage", "Symbol", "Shares", "Purchase Price", "Price", "Value"]
    assert_select "thead:nth-child(1)" do |element|
      assert_equal expected_headers, element[0].css('th')[1..-2].collect {|x| x.text}
    end
  end

  Shares_Col = 3
  Purchase_Price_Col = 4
  Price_Col = 5
  Value_Col = 6
  
  test "Holding Table has correct data" do
    get admin_holdings_url
    assert_response :success
    assert_select "table:nth-child(1) > tbody > tr" do |rows|
      expected_data = @user.holdings.joins(:ticker).order("tickers.symbol asc", shares: :desc).collect do |x|
        [x.account_name, x.brokerage, x.symbol, x.shares.to_f, x.purchase_price.to_f, x.price.to_f, x.value.to_f]
      end


      rows.each_with_index do |r, i|
        columns = r.css('td')[1..-2].collect { |x| x.text }
        columns[Shares_Col] = columns[Shares_Col].to_f
        [Purchase_Price_Col, Price_Col, Value_Col].each do |idx|
          assert columns[idx] =~ /^\$/, "Should show in currency format, column:#{idx} #{columns[idx]}"
          columns[idx] = columns[idx].gsub(/[\$,]/,'').to_f
        end
        assert_equal expected_data[i], columns, "Index table row is incorrect"
      end
    end
  end


  test "Summary Table has correct headings" do
    get admin_holdings_url
    assert_response :success
    expected_headers = ["Symbol", "Shares", "Price", "Value", "Description", "Expenses", "Us Equity", "Foreign Equity", "Bond", "Cash", "Other", "% of Portfolio"]
    assert_equal expected_headers, css_select("table#summary-tbl > thead > tr > th").collect {|h| h.text}, "headers"
  end
  
  test "Summary table has correct data" do
    column = {symbol: 0,
              shares: 1,
              price: 2,
              value: 3,
              description: 4,
              expenses: 5,
              us_equity: 6,
              foreign_equity: 7,
              bond: 8,
              cash: 9,
              other: 10,
              portfolio: 11}
    get admin_holdings_url
    assert_response :success
    formatter = ActionController::Base.helpers
    expected_table_data =  @user.summary_info.sort {|x,y| y.value <=> x.value}
    assert_select 'table#summary-tbl > tbody > tr' do |rows|
      rows.each_with_index do |r, i|
        ed = expected_table_data[i]
        assert_equal ed.symbol, r.css('td')[column[:symbol]].text, "#{ed.symbol}: Symbol"
        assert_equal formatter.number_to_currency(ed.value), r.css('td')[column[:value]].text, "#{ed.symbol}: value"
        assert_equal formatter.number_to_percentage(ed.cash * 100, precision: 0), r.css('td')[column[:cash]].text, "#{ed.symbol}: cash"
        assert_equal formatter.number_to_percentage(ed.percent * 100, precision: 2), r.css('td')[column[:portfolio]].text, "#{ed.symbol}: percent"
        
        if ed.symbol != "CASH" 
          assert_equal "%.1f" % ed.shares.round, r.css('td')[column[:shares]].text, "#{ed.symbol}: num shares"
          assert_equal formatter.number_to_currency(ed.price), r.css('td')[column[:price]].text, "#{ed.symbol}: price"
          assert_equal ed.description.to_s, r.css('td')[column[:description]].text, "#{ed.symbol}: description"
          assert_equal formatter.number_to_percentage(ed.expenses, precision: 2), r.css('td')[column[:expenses]].text, "#{ed.symbol}: expenses"
          assert_equal formatter.number_to_percentage(ed.us_equity * 100, precision: 0), r.css('td')[column[:us_equity]].text, "#{ed.symbol}: us equity"
          assert_equal formatter.number_to_percentage(ed.foreign_equity * 100, precision: 0), r.css('td')[column[:foreign_equity]].text, "#{ed.symbol}: foreign equity"
          assert_equal formatter.number_to_percentage(ed.bond * 100, precision: 0), r.css('td')[column[:bond]].text, "#{ed.symbol}: bond"
          assert_equal formatter.number_to_percentage(ed.other * 100, precision: 0), r.css('td')[column[:other]].text, "#{ed.symbol}: other"
        else
          assert_equal "", r.css('td')[column[:shares]].text, "#{ed.symbol}: num shares"
          assert_equal "", r.css('td')[column[:price]].text, "#{ed.symbol}: price"
          assert_equal "", r.css('td')[column[:description]].text, "#{ed.symbol}: description"
          assert_equal "", r.css('td')[column[:expenses]].text, "#{ed.symbol}: expenses"
          assert_equal "0%", r.css('td')[column[:us_equity]].text, "#{ed.symbol}: us equity"
          assert_equal "0%", r.css('td')[column[:foreign_equity]].text, "#{ed.symbol}: foreign equity"
          assert_equal "0%", r.css('td')[column[:bond]].text, "#{ed.symbol}: bond"
          assert_equal "0%", r.css('td')[column[:other]].text, "#{ed.symbol}: other"
        end
      end
    end
  end
  


  
end

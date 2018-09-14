require 'test_helper'

class TickerIntegrationTest < ActionDispatch::IntegrationTest
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

  test "ticker show returns success" do
    @user.tickers.each do |tick|
      get admin_ticker_url(tick)
      assert_response :success
    end
  end

  test "Ticker Index, Table has correct headings" do
    get admin_tickers_url
    assert_response :success
    expected_headers = ["Stype", "Group", "Price", "Price Date", "Expenses"]
    assert_select "thead:nth-child(1)" do |element|
      assert_equal expected_headers, element[0].css('th')[1..-2].collect {|x| x.text}
    end
  end

  test "Ticker Index, Table has correct data" do
    get admin_tickers_url
    assert_response :success
    ftr = ActionController::Base.helpers
    assert_select "table:nth-child(1) > tbody > tr" do |rows|
      expected_data = Ticker.all.order("tickers.symbol asc").collect do |t|
        [
          t.symbol,
          t.stype.to_s,
          t.group.to_s,
          t.last_price ? ftr.number_to_currency(t.last_price) : '-',
          t.last_price_date ? t.last_price_date.strftime('%B %d, %Y %H:%M') : '-',
          t.expenses ? ftr.number_to_percentage(t.expenses) : ""
        ]
      end
      rows.each_with_index do |r, i|
        columns = r.css('td')[0..-2].collect { |x| x.text }
        assert_equal expected_data[i], columns, "Index table row is incorrect"
      end
    end
  end

  test "Ticker show, details table correct headers" do
    tickers = [tickers(:SCHP), tickers(:VTV), tickers(:IBM)]

    tickers.each do |ticker|
      assert ticker 
      get admin_ticker_url(ticker)
      assert_response :success

      expected_headers = ["Symbol", "Name", "Stype"]

      if ticker.group
        expected_headers << "Group"
      end
      if ticker.expenses
        expected_headers << "Expenses"
      end

      if ticker.aa_us_stock
        expected_headers = expected_headers + ["Us Stock", "Non Us Stock", "Bond", "Cash", "Other"]
      end
      if ticker.quality
        expected_headers = expected_headers + ["Avg Bond Quality", "Aaa", "Aa", "A", "Bbb" , "Bb" , "B",
                                               "Below B", "Not Rated"]
      end
      if ticker.bs_government.to_f > 0
        expected_headers = expected_headers + ["Bond Government", "Bond Gov Tips", "Bond Gov Nominal",
                                               "Bond Corporate", "Bond Securitized", "Bond Other",
                                               "Bond Cash Equivilent"]
      end
      
      if ticker.ss_basic_material
        expected_headers = expected_headers + ["Basic Materials", "Consumer Cyclical", "Financial Services",
                                               "Realestate", "Communications Services", "Energy",
                                               "Industrials", "Technology", "Consumer Defensive",
                                               "Healthcare", "Utilities"]
      end
      
      if ticker.mr_americas
        expected_headers = expected_headers + ["Americas", "Greater Europe", "Greater Asia",
                                               "Developed", "Emerging"]
      end
      
      headers = css_select('table > tr > th').collect {|x| x.text}
      assert_equal expected_headers, headers
    end
  end

  test "Ticker show, details table correct data" do
    ticker = tickers(:SCHP)
    assert ticker
    get admin_ticker_url(ticker)
    assert_response :success
    ftr = ActionController::Base.helpers
    expected_data = [ticker.symbol, ticker.name, ticker.stype]
    if ticker.group
      expected_data << ticker.group
    end
    if ticker.expenses
      expected_data << ftr.number_to_percentage(ticker.expenses.to_f)
    end
    if ticker.aa_us_stock
      expected_data = expected_data + [ftr.number_to_percentage(ticker.aa_us_stock.to_f * 100, precision: 1),
                                       ftr.number_to_percentage(ticker.aa_non_us_stock.to_f * 100, precision: 1),
                                       ftr.number_to_percentage(ticker.aa_bond.to_f * 100, precision: 1),
                                       ftr.number_to_percentage(ticker.aa_cash.to_f * 100, precision: 1),
                                       ftr.number_to_percentage(ticker.aa_other.to_f * 100, precision: 1)
      ]
    end
    if ticker.quality
      expected_data = expected_data +
                      [
                        ticker.quality,
                        ftr.number_to_percentage(ticker.cq_aaa.to_f * 100, precision: 1),
                        ftr.number_to_percentage(ticker.cq_aa.to_f * 100, precision: 1),
                        ftr.number_to_percentage(ticker.cq_a.to_f * 100, precision: 1),
                        ftr.number_to_percentage(ticker.cq_bbb.to_f * 100, precision: 1),
                        ftr.number_to_percentage(ticker.cq_bb.to_f * 100, precision: 1),
                        ftr.number_to_percentage(ticker.cq_b.to_f * 100, precision: 1),
                        ftr.number_to_percentage(ticker.cq_below_b.to_f * 100, precision: 1),
                        ftr.number_to_percentage(ticker.cq_not_rated.to_f * 100, precision: 1),
                      ]

    end
    if ticker.bs_government.to_f > 0
      expected_data = expected_data +
                      [
                        ftr.number_to_percentage(ticker.bs_government.to_f * 100, precision: 1),
                        ftr.number_to_percentage(ticker.gov_tips.to_f * 100, precision: 1),
                        ftr.number_to_percentage(ticker.gov_nominal.to_f * 100, precision: 1),
                        ftr.number_to_percentage(ticker.bs_corporate.to_f * 100, precision: 1),
                        ftr.number_to_percentage(ticker.bs_securitized.to_f * 100, precision: 1),
                        ftr.number_to_percentage(ticker.bs_other.to_f * 100, precision: 1),
                        ftr.number_to_percentage(ticker.bs_cash.to_f * 100, precision: 1),
                      ]
    end
    
    if ticker.ss_basic_material
      expected_data = expected_data +
                      [
                        ftr.number_to_percentage(ticker.ss_basic_materials.to_f * 100, precision: 1),
                        ftr.number_to_percentage(ticker.ss_consumer_cyclical.to_f * 100, precision: 1),
                        ftr.number_to_percentage(ticker.ss_financial_services.to_f * 100, precision: 1),
                        ftr.number_to_percentage(ticker.ss_realestate.to_f * 100, precision: 1),
                        ftr.number_to_percentage(ticker.ss_communications_services.to_f * 100, precision: 1),
                        ftr.number_to_percentage(ticker.ss_energy.to_f * 100, precision: 1),
                        ftr.number_to_percentage(ticker.ss_industrials.to_f * 100, precision: 1),
                        ftr.number_to_percentage(ticker.ss_technology.to_f * 100, precision: 1),
                        ftr.number_to_percentage(ticker.ss_consumer_defensive.to_f * 100, precision: 1),
                        ftr.number_to_percentage(ticker.ss_healthcare.to_f * 100, precision: 1),
                        ftr.number_to_percentage(ticker.ss_utilities.to_f * 100, precision: 1),
                      ]
    end
    
    if ticker.mr_americas
      expected_data = expected_data +
                      [
                        ftr.number_to_percentage(ticker.mr_americas.to_f * 100, precision: 1),
                        ftr.number_to_percentage(ticker.mr_greater_europe.to_f * 100, precision: 1),
                        ftr.number_to_percentage(ticker.mr_greater_asia.to_f * 100, precision: 1),
                        ftr.number_to_percentage(ticker.mc_developed.to_f * 100, precision: 1),
                        ftr.number_to_percentage(ticker.mc_emerging.to_f * 100, precision: 1),
                      ]
    end
    headers = css_select('table > tr > th').collect {|x| x.text}
    data = css_select('table > tr > td').collect {|x| x.text}
    headers.each_with_index do |h,i|
      if expected_data[i]
        assert_equal expected_data[i], data[i], "#{h} not correct"
      else
        assert_match /empty/i, data[i], "\n*** #{h} not correct ***\n"
      end
    end
  end

end 

require "application_system_test_case"

class HoldingsSystemTest < ApplicationSystemTestCase
  include Warden::Test::Helpers
  LauraPassword = 'laura_pw'
  AdminPassword = "admin_pw"

  def verify_login(email, password)
    assert_equal "/admin/login", current_path
    assert_selector  "div#login"
    fill_in "admin_user_email", with: email
    fill_in "admin_user_password", with: password
    submit_button = self.find_by_id("admin_user_submit_action")
    assert submit_button
    submit_button.click
  end

  def setup
    visit new_admin_user_session_url
    @user = admin_users(:laura)
    verify_login(@user.email, LauraPassword)
    visit admin_holdings_url
  end
  
  test "should have title 'holdings'" do
    title = find("#page_title")
    assert title, "Should have page title"
    assert_equal "Holdings", title.text, 'Should have title "Holdings"'
  end

  test "Should have correct filters" do
    filter_sidebar = find("#filters_sidebar_section")
    assert filter_sidebar, "Filters sidebar should be on page"
    within (filter_sidebar) do
      filter_form = find('.filter_form')
      assert filter_form, "Filter form should be on page"
      within (filter_form) do
        assert find("#q_ticker_symbol"), "Should have ticker_symbol filter"
        assert find("#q_account_name"), "Should have account name filter"
        assert find("#q_account_brokerage"), "Should have  brokerage filter"
        assert find("#q_shares"), "Should have shares filter"
      end
    end
  end

  ACCOUNT_COL = 1
  BROKERAGE_COL = 2
  SYMBOL_COL = 3
  SHARES_COL = 4

  test "filter Symbol filter contains" do
    search_term = @user.holdings.first.symbol
    within("#q_ticker_symbol_input") do
      select("Contains")
      fill_in("Ticker symbol", with: search_term)
    end
    click_on("Filter")
    expected_holdings = @user.holdings.find_all { |x| x.symbol =~ /#{search_term}/ }
    within("#index_table_holdings") do 
      rows = all('tr')
      assert_equal expected_holdings.count, all('tr').count - 1, "Should have #{expected_holdings.count} holdings with that contain #{search_term}"
      rows[1..-1].each do |r|
        symbol = r.all('td')[SYMBOL_COL].text
        assert symbol =~ /#{search_term}/, "Expected symbol in row #{symbol} to match #{search_term}"
      end
      
    end

  end
  
  test "filter account name  ends with" do
    search_term = "deferred"
    within("#q_account_name_input") do
      select("Ends with")
      fill_in("Account name", with: search_term)
    end
    click_on("Filter")
    expected_holdings = @user.holdings.find_all { |x| x.account_name =~ /#{search_term}$/ }
    within("#index_table_holdings") do 
      rows = all('tr')
      assert_equal expected_holdings.count, all('tr').count - 1, "Should have #{expected_holdings.count} holdings with that contain #{search_term}"
      rows[1..-1].each do |r|
        account_name = r.all('td')[ACCOUNT_COL].text
        assert  account_name =~ /#{search_term}$/, "Expected account name in row #{account_name} to end in #{search_term}"
      end
    end
  end
  
  test "filter Brokerage equals" do
    search_term = @user.holdings.first.brokerage
    within("#q_account_brokerage_input") do
      select("Equals")
      fill_in("Brokerage", with: search_term)
    end
    click_on("Filter")
    expected_holdings = @user.holdings.find_all { |x| x.brokerage == search_term }
    within("#index_table_holdings") do 
      rows = all('tr')
      assert_equal expected_holdings.count, all('tr').count - 1, "Should have #{expected_holdings.count} holdings with that contain #{search_term}"
      rows[1..-1].each do |r|
        brokerage = r.all('td')[BROKERAGE_COL].text
        assert_equal search_term, brokerage, "Expected brokerage in row #{brokerage} to match #{search_term}"
      end
    end
  end

  test "Filter shares equals" do
    search_term = @user.holdings.order(shares: :desc).second.shares
    assert_selector  "#q_shares_input"
    within("#q_shares_input") do
      select("Equals")
      fill_in("Shares", with: search_term)
    end
    click_on("Filter")
    expected_holdings = @user.holdings.find_all { |x| x.shares.to_f == search_term.to_f }
    within("#index_table_holdings") do 
      rows = all('tr')
      assert_equal expected_holdings.count, all('tr').count - 1, "Should have #{expected_holdings.count} holdings with that contain #{search_term}"
      rows[1..-1].each do |r|
        num_shares = r.all('td')[SHARES_COL].text.gsub(/[\$,]/,'').to_f
        assert_equal search_term.to_f, num_shares, "Expected shares in row #{num_shares} to be equal to  #{search_term}"
      end
    end
  end

  

end



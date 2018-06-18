require "application_system_test_case"

class HoldingsTest < ApplicationSystemTestCase
  include Warden::Test::Helpers
  UserPassword = 'laura_pw'
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

  #
  #  non Admin User
  #

  test "regular user visiting admin user index " do
    visit admin_users_url
    user = admin_users(:laura)
    verify_login(user.email, UserPassword)
    assert_equal "/admin/users", current_path
    title = find_by_id("page_title")
    assert_equal "Users", title.text
    table = find_by_id("index_table_users")
    assert table
    num_rows = 2 # Header plus one data row
    assert_equal num_rows, table.find_all('tr').count
    user_row = find_by_id("admin_user_#{user.id}")
    assert user_row
  end
  test "regular user visiting holdings index" do
    visit admin_holdings_url
    user = admin_users(:laura)
    verify_login(user.email, UserPassword) 
    assert_equal "/admin/holdings", current_path
    title = find_by_id("page_title")
    assert_equal "Holdings", title.text
    table = find_by_id("index_table_holdings")
    assert table
    count = user.holdings.count
    num_rows = count + 1
    assert_equal num_rows, table.find_all('tr').count
    user.holdings.each do |h|
      assert page.has_text?(h.symbol)
    end
  end

  test "regular user visiting accounts index" do
    visit admin_accounts_url
    user = admin_users(:laura)
    verify_login(user.email, UserPassword) 
    assert_equal "/admin/accounts", current_path
    title = find_by_id("page_title")
    assert_equal "Accounts", title.text
    table = find_by_id("index_table_accounts")
    assert table
    count = user.accounts.count
    num_rows = count + 1
    assert_equal num_rows, table.find_all('tr').count
    user.accounts.each do |a|
      assert page.has_text?(a.name)
    end
  end
  
  test "regulare user visiting root index" do
    visit root_url
    verify_login(admin_users(:laura).email, UserPassword)
    assert_equal "/", current_path
    title = find_by_id("page_title")
    assert_equal "Accounts", title.text
  end

  test "visiting Earnings index" do
    visit admin_earnings_url
    verify_login(admin_users(:admin).email, AdminPassword)
    assert_equal "/admin/earnings", current_path
    title = find_by_id("page_title")
    assert_equal "Earnings", title.text
  end
  
  test "visiting Prices index" do
    visit admin_prices_url
    verify_login(admin_users(:laura).email, UserPassword)
    assert_equal "/admin/prices", current_path
    title = find_by_id("page_title")
    assert_equal "Prices", title.text
  end

  test "visiting Tickers index" do
    visit admin_tickers_url
    verify_login(admin_users(:laura).email, UserPassword)
    assert_equal "/admin/tickers", current_path
    title = find_by_id("page_title")
    assert_equal "Tickers", title.text
  end

  test "visiting SS_Factors index" do
    visit admin_ss_factors_url
    verify_login(admin_users(:admin).email, AdminPassword)
    assert_equal "/admin/ss_factors", current_path
    title = find_by_id("page_title")
    assert_equal "Ss Factors", title.text
  end

  test "visiting dashboard" do
    visit admin_dashboard_url
    verify_login(admin_users(:laura).email, UserPassword)
    assert_equal "/admin/dashboard", current_path
    title = find_by_id("page_title")
    assert_equal "Dashboard", title.text
  end
  
end

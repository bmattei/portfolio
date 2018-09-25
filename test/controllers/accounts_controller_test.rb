require 'test_helper'
class AccountsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    sign_in admin_users(:laura)
  end
  test "should get index" do
    get admin_accounts_url
    assert_response :success
  end

  test "should get show page for account" do
    account = accounts(:lauraTaxable)
    get admin_account_url(account)
    assert_response :success
    assert_select '#page_title', account.name 
  end

  test "show page for account should have two tables" do
    account = accounts(:lauraTaxable)
    get admin_account_url(account)
    assert_response :success
    assert_select "table", 2
  end
  NAME_ROW_NUM = 0
  BROKERAGE_ROW_NUM = 1
  ACCOUNT_TYPE_ROW_NUM = 2
  HOLDINGS_VALUE_ROW_NUM = 3
  CASH_ROW_NUM = 4
  TOTAL_VALUE_ROW_NUM = 5
  test "First table has correct data" do
    account = accounts(:lauraTaxable)
    account.update_values
    get admin_account_url(account)
    assert_response :success
    tables = css_select('table')
    assert_equal 2, tables.count
    headings = tables[0].css('th').collect {|x| x.text}
    expected_headings = ["Name", "Brokerage", "Account Type", "Holdings Value", "Cash", "Total Value"]
    assert_equal expected_headings, headings
    rows = tables[0].css('tr')
    assert_equal account.name, rows[NAME_ROW_NUM].css('td').text
    assert_equal account.brokerage, rows[BROKERAGE_ROW_NUM].css('td').text
    assert_equal account.account_type.name, rows[ACCOUNT_TYPE_ROW_NUM].css('td').text
    assert_equal account.holdings_value.to_f, rows[HOLDINGS_VALUE_ROW_NUM].css('td').text.gsub(/[\$,]/,'').to_f
    assert_equal account.cash.to_f, rows[CASH_ROW_NUM].css('td').text.gsub(/[\$,]/,'').to_f
    assert_equal account.total_value.to_f, rows[TOTAL_VALUE_ROW_NUM].css('td').text.gsub(/[\$,]/,'').to_f
  end
  
  test "Holdings Table has correct data" do
    account = accounts(:lauraTaxable)
    account.update_values
    get admin_account_url(account)
    assert_response :success
    tables = css_select('table')
    assert_equal 2, tables.count
    table = tables[1]
    headings = table.css('th').collect {|x| x.text}
    expected_headings = ["Symbol", "Shares", "Purchase Price", "Price", "Value"]
    assert_equal expected_headings, headings, "Heading of holdings table"
    rows = table.css('tr')
    assert_equal account.holdings.count + 1, rows.count
    i = 0
    account.holdings.joins(:ticker).order("tickers.symbol asc").each do |h|
      i = i + 1
      columns = rows[i].css('td')
      assert_equal h.symbol, columns[0].text
      assert_equal h.shares.round(2).to_f, columns[1].text.to_f
      assert_equal h.purchase_price.to_f, columns[2].text.gsub(/[\$,]/,'').to_f
      assert_equal h.price.to_f, columns[3].text.gsub(/[\$,]/,'').to_f
      assert_equal h.value.to_f, columns[4].text.gsub(/[\$,]/,'').to_f
    end
  end

end

require 'test_helper'

class AdminAccountIntegrationTest < ActionDispatch::IntegrationTest

  BROKERAGE_IDX = 2
  TAX_STATUS_IDX = 3
  HOLDINGS_VALUE_IDX = 4
  FREE_CASH_IDX = 5
  HOLDING_CASH_IDX = 6
  STOCK_IDX = 7
  BOND_IDX = 8
  OTHER_IDX = 9
  TOTAL_IDX = 10

  def setup
    @user = admin_users(:laura)
    params = {"admin_user"=>  { 'email' =>  @user.email,
                                "password" =>  'laura_pw'
                              }
             }
    post '/admin/login', params: params
    pp response.body
    assert_equal 302, status
    follow_redirect!
    assert_equal 200, status
  end
  test  "Admin Accounts index returns success" do
    get admin_accounts_url
    assert_response :success

  end
  test "Admin Accounts Index title and headers" do
    get admin_accounts_url
    assert_response :success
    assert_select "h2", "Accounts", "Title Accounts not found"
    ["Name", "Brokerage", "Tax Status", "Free Cash", "Holdings Cash", "Stock", "Bond", "Other",
     "Total Value"].each do |hdr_str|
      assert_select "th", hdr_str, "Header #{hdr_str} not found"
    end
  end
  test "All Users accounts are listed" do
    get admin_accounts_url
    assert_response :success
    account_names = @user.accounts.collect {|x| x.name}
    assert_select "table#index_table_accounts tbody" do |elements|
      assert_equal account_names.count, elements[0].css('tr').count, "Should have #(account_names.count} accounts"
    end
      account_names.each do |name|
        assert_select "td", name, "Account #{name} for user @{user.email} not listed"
      end
  end

  test "User account brokerage is correct" do
    get admin_accounts_url
    assert_response :success
    accounts = @user.accounts.order(total_value: :desc)
    assert_select "table#index_table_accounts tbody" do |elements|
      assert_select "tr" do  |elements|
        i = 0
        elements.each do |row|
          txt =  row.css('td')[BROKERAGE_IDX].text
          assert_equal accounts[i].brokerage, txt
          i = i + 1
          break if i >= accounts.count
        end
      end
    end
  end
  test "User account tax status is correct" do
    get admin_accounts_url
    assert_response :success
    accounts = @user.accounts.order(total_value: :desc)
    assert_select "table#index_table_accounts tbody" do |elements|
      assert_select "tr" do  |elements|
        i = 0
        elements.each do |row|
          txt =  row.css('td')[TAX_STATUS_IDX].text
          assert_equal accounts[i].account_type.name, txt
          i = i + 1
          break if i >= accounts.count
        end
      end
    end
  end

  test "User account holdings value is correct" do
    get admin_accounts_url
    assert_response :success
    accounts = @user.accounts.order(total_value: :desc)
    assert_select "table#index_table_accounts tbody" do |elements|
      assert_select "tr" do  |elements|
        i = 0
        elements.each do |row|
          txt =  row.css('td')[HOLDINGS_VALUE_IDX].text
          number = txt.gsub(/[\$,]/,'').to_f
          # Fixtures do not run callbacks. So need to save to insure
          # holding_value is calculated and stored
          accounts[i].save 
          assert_equal accounts[i].holdings_value, number
          i = i + 1
          break if i >= accounts.count
        end
      end
    end
  end
  

  test "User account free_cash is correct" do
    get admin_accounts_url
    assert_response :success
    accounts = @user.accounts.order(total_value: :desc)
    assert_select "table#index_table_accounts tbody" do |elements|
      assert_select "tr" do  |elements|
        i = 0
        elements.each do |row|
          txt =  row.css('td')[FREE_CASH_IDX].text
          number = txt.gsub(/[\$,]/,'').to_f
          assert_equal accounts[i].cash, number
          i = i + 1
          break if i >= accounts.count
        end
      end
    end
  end

   test "User account holdings cash is correct" do
    get admin_accounts_url
    assert_response :success
    accounts = @user.accounts.order(total_value: :desc)
    assert_select "table#index_table_accounts tbody" do |elements|
      assert_select "tr" do  |elements|
        i = 0
        elements.each do |row|
          txt =  row.css('td')[HOLDING_CASH_IDX].text
          number = txt.gsub(/[\$,]/,'').to_f
          # Fixtures do not run callbacks. So need to save to insure
          # holding_value is calculated and stored
          accounts[i].save 
          assert_equal accounts[i].segment_amount(:cash), number
          i = i + 1
          break if i >= accounts.count
        end
      end
    end
   end

   test "User account holdings stock is correct" do
    get admin_accounts_url
    assert_response :success
    accounts = @user.accounts.order(total_value: :desc)
    assert_select "table#index_table_accounts tbody" do |elements|
      assert_select "tr" do  |elements|
        i = 0
        elements.each do |row|
          txt =  row.css('td')[STOCK_IDX].text
          number = txt.gsub(/[\$,]/,'').to_f
          # Fixtures do not run callbacks. So need to save to insure
          # holding_value is calculated and stored
          accounts[i].save
          assert_equal accounts[i].segment_amount(:stock).round(2).to_f, number.round(2)
          i = i + 1
          break if i >= accounts.count
        end
      end
    end
   end

   test "User account holdings bond is correct" do
    get admin_accounts_url
    assert_response :success
    accounts = @user.accounts.order(total_value: :desc)
    assert_select "table#index_table_accounts tbody" do |elements|
      assert_select "tr" do  |elements|
        i = 0
        elements.each do |row|
          txt =  row.css('td')[BOND_IDX].text
          number = txt.gsub(/[\$,]/,'').to_f
          # Fixtures do not run callbacks. So need to save to insure
          # holding_value is calculated and stored
          accounts[i].save
          assert_equal accounts[i].segment_amount(:bond).to_f, number.to_f
          i = i + 1
          break if i >= accounts.count
        end
      end
    end
   end

   test "User account holdings other is correct" do
    get admin_accounts_url
    assert_response :success
    accounts = @user.accounts.order(total_value: :desc)
    assert_select "table#index_table_accounts tbody" do |elements|
      assert_select "tr" do  |elements|
        i = 0
        elements.each do |row|
          txt =  row.css('td')[OTHER_IDX].text
          number = txt.gsub(/[\$,]/,'').to_f
          # Fixtures do not run callbacks. So need to save to insure
          # holding_value is calculated and stored
          accounts[i].save
          assert_equal accounts[i].segment_amount(:other).round(2).to_f, number.round(2).to_f
          i = i + 1
          break if i >= accounts.count
        end
      end
    end
  end
  

  test "User account total_value is correct" do
    get admin_accounts_url
    assert_response :success
    account_totals = @user.accounts.order(total_value: :desc).collect {|x| x.total_value}
    assert_select "table#index_table_accounts tbody" do |elements|
      assert_select "tr" do  |elements|
        i = 0
        elements.each do |row|
          txt =  row.css('td')[TOTAL_IDX].text
          number = txt.gsub(/[\$,]/,'').to_f
          assert_equal account_totals[i], number
          i = i + 1
          break if i >= account_totals.count
        end
      end
    end
  end

  test "Verify Accounts free cash" do
    get admin_accounts_url
    assert_response :success


  end
  test "Admin Accounts show returns success" do
    account = accounts(:lauraTaxable)
    assert account
    get admin_account_url(account)
    assert_response :success
  end

  test  "User only has access to their own accounts" do
    account = accounts(:maryTaxFree)
    assert account
    assert_raises(Exception) { get admin_account_url(account) }
  end

  

end

require "application_system_test_case"

class AccountSystemTest < ApplicationSystemTestCase
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

  test "admin user filter is shown for admin user" do
    visit new_admin_user_session_url
    user = admin_users(:admin)
    verify_login(user.email, AdminPassword)
    assert_equal "/admin", current_path
    title = find_by_id("page_title")
    assert_equal "Accounts", title.text
    page.has_selector?("#q_admin_user_email")
  end

  test "admin user filter is not shown for non admin user" do
    visit new_admin_user_session_url
    user = admin_users(:admin)
    verify_login(user.email, AdminPassword)
    assert_equal "/admin", current_path
    title = find_by_id("page_title")
    assert_equal "Accounts", title.text
    page.has_no_selector?("#q_admin_user_email")
  end

  # ACCOUNT NAME FILTER
  test "name filter contains" do
    visit new_admin_user_session_url
    user = admin_users(:laura)
    verify_login(user.email, LauraPassword)
    search_term = "deferred"
    within("#q_name_input") do
      select("Contains")
      fill_in("Name", with: search_term)
    end
    click_on("Filter")
    within("#index_table_accounts") do
      user.accounts.each do |account|
        if account.name =~ /#{search_term}/
          assert_equal 1, all('td', text: account.name).count, "Should find accounts that do contain account name: #{search_term}."
        else
          assert_equal 0, all('td', text: account.name).count, "Should not find accounts that do contain account name: #{search_term}."
        end      
      end
    end
  end
  test "name filter equals" do
    visit new_admin_user_session_url
    user = admin_users(:laura)
    verify_login(user.email, LauraPassword)
    search_term = "laura tax free"
    within("#q_name_input") do
      select("Equals")
      fill_in("Name", with: search_term)
    end
    click_on("Filter")
    within("#index_table_accounts") do
      user.accounts.each do |account|
        if account.name =~ /#{search_term}/
          assert_equal 1, all('td', text: account.name).count, "Should find accounts that do equal account name: #{search_term}."
        else
          assert_equal 0, all('td', text: account.name).count, "Should not find accounts that do equal account name: #{search_term}."
        end      
      end
    end
  end

  test "name filter ends with" do
    visit new_admin_user_session_url
    user = admin_users(:laura)
    verify_login(user.email, LauraPassword)
    search_term = "tax free"
    within("#q_name_input") do
      select("Ends with")
      fill_in("Name", with: search_term)
    end
    click_on("Filter")
    within("#index_table_accounts") do
      user.accounts.each do |account|
        if account.name =~ /#{search_term}$/
          assert_equal 1, all('td', text: account.name).count, "Should find accounts that do Ends with account name: #{search_term}."
        else
          assert_equal 0, all('td', text: account.name).count, "Should not find accounts that do Ends with account name: #{search_term}."
        end      
      end
    end
  end

  # Brokerage Filter Contains

  test "brokerage filter contains" do
    visit new_admin_user_session_url
    user = admin_users(:laura)
    verify_login(user.email, LauraPassword)
    search_term = "idel"
    within("#q_brokerage_input") do
      select("Contains")
      fill_in("Brokerage", with: search_term)
    end
    click_on("Filter")
    within("#index_table_accounts") do
      user.accounts.each do |account|
        if account.brokerage =~ /#{search_term}/
          assert_equal 1, all('td', text: account.brokerage).count, "Should find accounts that do contain account brokerage: #{search_term}."
        else
          assert_equal 0, all('td', text: account.brokerage).count, "Should not find accounts that do contain account brokerage: #{search_term}."
        end      
      end
    end
  end

  test "brokerage filter equals" do
    visit new_admin_user_session_url
    user = admin_users(:laura)
    verify_login(user.email, LauraPassword)
    search_term = "Fidelity"
    within("#q_brokerage_input") do
      select("Equals")
      fill_in("Brokerage", with: search_term)
    end
    click_on("Filter")
    within("#index_table_accounts") do
      user.accounts.each do |account|
        if account.brokerage =~ /#{search_term}/
          assert_equal 1, all('td', text: account.brokerage).count, "Should find accounts that do equal brokerage: #{search_term}."
        else
          assert_equal 0, all('td', text: account.brokerage).count, "Should not find accounts that do equal brokerage: #{search_term}."
        end      
      end
    end
  end

  test "brokerage filter ends with" do
    visit new_admin_user_session_url
    user = admin_users(:laura)
    verify_login(user.email, LauraPassword)
    search_term = "rade"
    within("#q_brokerage_input") do
      select("Ends with")
      fill_in("Brokerage", with: search_term)
    end
    click_on("Filter")
    within("#index_table_accounts") do
      user.accounts.each do |account|
        if account.brokerage =~ /#{search_term}$/
          assert_equal 2, all('td', text: account.brokerage).count, "Should find accounts that do Ends with account brokerage: #{search_term}."
        else
          assert_equal 0, all('td', text: account.brokerage).count, "Should not find accounts that do Ends with account brokerage: #{search_term}."
        end      
      end
    end
  end

  # Cash Filter

  # //*[@id="best_in_place_account_5_cash"]
  CASH_COL = 6
  # Can't get this test to run.  Dropdown selection is getting reset to "Equals" not sure why
  # test "Cash Greater Then" do
  #   visit new_admin_user_session_url
  #   user = admin_users(:laura)
  #   verify_login(user.email, LauraPassword)
  #   amount = 1000
  #   within("#q_cash_input") do
  #     select("Greater than")
  #     fill_in("Cash", with: amount)
  #   end
  #   click_on("Filter")
  #   byebug
  #   within("#index_table_accounts") do
  #     rows = all('tr')
  #     matching_accounts = user.accounts.all.find_all {|x| x.cash > amount}
  #     assert_equal matching_accounts.count, rows.count - 1, "Should have found  #{matching_accounts.count} that had cash > #{amount}"
  #     (1..rows.count).each do |idx|
  #       cash_str = rows[idx].all('td')[CASH_COL].text
  #       cash_amount = cash_str.gsub(/[\$,]/,'').to_f
  #       assert cash_amount > amount, "Should no be displaying an account with #{cash_amount}"
  #     end
  #   end
  #
  #end

  test "Cash Equals" do
    visit new_admin_user_session_url
    user = admin_users(:laura)
    verify_login(user.email, LauraPassword)
    amount = 1000
    within("#q_cash_input") do
      select("Equals")
      fill_in("Cash", with: amount)
    end
    click_on("Filter")
    within("#index_table_accounts") do
      rows = all('tr')
      matching_accounts = user.accounts.all.find_all {|x| x.cash == amount}
      assert_equal matching_accounts.count, rows.count - 1, "Should have found  #{matching_accounts.count} that had cash > #{amount}"
      (1...rows.count).each do |idx|
        cash_str = rows[idx].all('td')[CASH_COL].text
        cash_amount = cash_str.gsub(/[\$,]/,'').to_f
        assert_equal cash_amount, amount, "Should not be displaying an account with #{cash_amount}"
      end
    end
  
  end

  TOTAL_VALUE_COL = 11
  test "Total Value Equals than" do
    visit new_admin_user_session_url
    user = admin_users(:laura)
    verify_login(user.email, LauraPassword)
    amount = user.accounts[rand(user.accounts.count)].total_value
    within("#q_total_value_input") do
      select("Equals")
      fill_in("Total value", with: amount)
    end
    click_on("Filter")
    within("#index_table_accounts") do
      rows = all('tr')
      matching_accounts = user.accounts.all.find_all {|x| x.total_value ==  amount}
      assert_equal matching_accounts.count, rows.count - 1, "Should have found  #{matching_accounts.count} that had cash > #{amount}"
      (1...rows.count).each do |idx|
        cash_str = rows[idx].all('td')[TOTAL_VALUE_COL].text
        cash_amount = cash_str.gsub(/[\$,]/,'').to_f
        assert_equal cash_amount, amount, "Should no be displaying an account with #{cash_amount}"
      end
    end
  
  end

  test "Account Type Table" do
    visit new_admin_user_session_url
    user = admin_users(:laura)

    verify_login(user.email, LauraPassword)
    table = all('table')[1]
    assert table

    rows = table.all('tr')
    expected_num_rows = 5
    assert_equal expected_num_rows, rows.count

    hdr_cols = rows[0].all('th')
    expected_num_columns = 4
    assert_equal expected_num_columns, hdr_cols.count

    hdr_col_text_array = hdr_cols.collect {|x| x.text }
    expected_headers = ["Account Type", "Holding Value", "Cash", "Total Value"]
    assert_equal expected_headers, hdr_col_text_array

    types = ["TaxFree", "Tax Deferred", "Taxable", "All Accounts"]
    string_to_type_id = {"TaxFree" => 3, "Tax Deferred" =>  2, "Taxable" => 1, "All Accounts" => [1,2,3] }
    (1...rows.count).each do |i|
      columns = rows[i].all('td')
      assert_equal expected_num_columns, columns.count
      account_type = columns[0].text
      assert_equal types[i-1], account_type, "Incorrect account type"

      account_type_id = string_to_type_id[account_type]
      holdings_value = user.accounts.where(account_type_id: account_type_id).sum(:holdings_value).to_f
      cash_value = user.accounts.where(account_type_id: account_type_id).sum(:cash).to_f
      total_value = user.accounts.where(account_type_id: account_type_id).sum(:total_value).to_f

      assert_equal holdings_value, columns[1].text.gsub(/[$,]/,"").to_f
      assert_equal cash_value, columns[2].text.gsub(/[$,]/,"").to_f
      assert_equal total_value, columns[3].text.gsub(/[$,]/,"").to_f
      
    end
    
  end

  NUM_TABLES = 3
  test "Brokerage Table" do
    visit new_admin_user_session_url
    user = admin_users(:laura)

    verify_login(user.email, LauraPassword)
    table_list = all('table')
    assert_equal NUM_TABLES, table_list.count
    table = table_list[2]
    assert table
    rows = table.all('tr')
    brokerages = user.accounts.collect {|x| x.brokerage}.uniq
    assert_equal brokerages.count + 1, rows.count

    # check headers
    hdr_cols = rows[0].all('th')
    expected_num_columns = 4
    assert_equal expected_num_columns, hdr_cols.count

    hdr_col_text_array = hdr_cols.collect {|x| x.text }
    expected_headers = ["Brokerage", "Holding Value", "Cash", "Total Value"]
    assert_equal expected_headers, hdr_col_text_array
    brokerage_info = {}
    brokerages_in_table = []
    saved_total_value = nil
    (1...rows.count).each do |i|
      columns = rows[i].all('td')
      assert_equal expected_num_columns, columns.count
      brokerage_name = columns[0].text
      assert  brokerages.include?(brokerage_name), "Unexpected brokerage name #{brokerage_name}"

      assert_not brokerages_in_table.include?(brokerage_name), "Brokerages #{brokerage_name} appears in table multiple times"

      brokerages_in_table << brokerage_name
     

      holdings_value = user.accounts.where(brokerage: brokerage_name).sum(:holdings_value).to_f
      total_value = user.accounts.where(brokerage: brokerage_name).sum(:total_value).to_f

      if saved_total_value
        assert saved_total_value >= total_value, "Rows are expected to be in desc total_value order #{i -1} : #{saved_total_value} #{i} #{total_value}"
      end
      saved_total_value = total_value

      cash_value = user.accounts.where(brokerage: brokerage_name).sum(:cash).to_f 

      assert_equal holdings_value , columns[1].text.gsub(/[$,]/,"").to_f, "holdings_value brokerage: #{brokerage_name}"
      assert_equal cash_value, columns[2].text.gsub(/[$,]/,"").to_f, "cash_value brokerage: #{brokerage_name}"
      assert_equal total_value, columns[3].text.gsub(/[$,]/,"").to_f, "total_value brokerage: #{brokerage_name}"
      
    end
   
  end
end


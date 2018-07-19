require "application_system_test_case"

class AccountTest < ApplicationSystemTestCase
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
    user_filter = find_by_id("q_admin_user_email")
    assert user_filter
  end

  test "admin user filter is not shown for non admin user" do
    visit new_admin_user_session_url
    user = admin_users(:admin)
    verify_login(user.email, AdminPassword)
    assert_equal "/admin", current_path
    title = find_by_id("page_title")
    assert_equal "Accounts", title.text
    user_filter = find_by_id("q_admin_user_email")
  end
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
    user.accounts.each do |account|
      if account.name =~ /#{search_term}/
        assert_equal 1, all('td', text: account.name).count, "Should find accounts that do contain account name: #{search_term}."
      else
        assert_equal 0, all('td', text: account.name).count, "Should not find accounts that do contain account name: #{search_term}."
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
    user.accounts.each do |account|
      pp account
      if account.name =~ /#{search_term}/
        assert_equal 1, all('td', text: account.name).count, "Should find accounts that do equal account name: #{search_term}."
      else
        assert_equal 0, all('td', text: account.name).count, "Should not find accounts that do equal account name: #{search_term}."
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
    user.accounts.each do |account|
      pp account
      if account.name =~ /#{search_term}^/
        assert_equal 1, all('td', text: account.name).count, "Should find accounts that do Ends with account name: #{search_term}."
      else
        assert_equal 0, all('td', text: account.name).count, "Should not find accounts that do Ends with account name: #{search_term}."
      end      
    end
  end
end


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
    assert_not user_filter
  end
end
                 

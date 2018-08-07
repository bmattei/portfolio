require 'test_helper'

class HoldingAccountIntegrationTest < ActionDispatch::IntegrationTest
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

  test "Holding Show Returns Success" do
    @user.tickers.each do |tick|
      get admin_ticker_url(tick)
      assert_response :success
    end
  end


end

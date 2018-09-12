require 'test_helper'
class CaptureIntegrationTest < ActionDispatch::IntegrationTest
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
    @user.new_capture
  end

  test "Capture Show Returns Success" do
    @user.captures.each do |cap|
      get admin_capture_url(cap)
      assert_response :success
    end
  end

  test "Capture index page title" do
    get admin_captures_url
    assert_response :success
    assert_select("#title_bar") do
      assert_select "h2", "Captures", "Expect title to be Captures"
    end
  end

  test "Capture Table has correct headings" do
    get admin_captures_url
    assert_response :success
    expected_headers = ["Total", "Holdings Value", "Cash", "Stocks", "Bonds", "Other"]
    assert_select "thead:nth-child(1)" do |element|
      assert_equal expected_headers, element[0].css('th')[1..-2].collect {|x| x.text}
    end
  end

  test "Capture Table has correct data" do
    get admin_captures_url
    assert_response :success
    ftr = ActionController::Base.helpers
    assert_select "table:nth-child(1) > tbody > tr" do |rows|
      expected_data = Capture.all.order(capture_date: :desc).collect do |c|
        [
          c.created_at.strftime('%B %d, %Y %H:%M'),
          ftr.number_to_currency(c.total_value),
          ftr.number_to_currency(c.holdings_value),
          ftr.number_to_currency(c.cash),
          ftr.number_to_currency(c.segment_amount('stock')),
          ftr.number_to_currency(c.segment_amount('bond')),
          ftr.number_to_currency(c.segment_amount('other'))

        ]
      end
      rows.each_with_index do |r, i|
        columns = r.css('td')[0..-2].collect { |x| x.text }
        assert_equal expected_data[i], columns, "Index table row is incorrect"
      end
    end
  end




end

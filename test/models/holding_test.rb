require 'test_helper'

class HoldingTest < ActiveSupport::TestCase
   test "Holding must have ticker" do
     holding = Holding.new
     holding.account = Account.first
     assert_not holding.save, "Saved without a Ticker"
   end
   test "Holding must have account" do
     holding = Holding.new
     holding.ticker = Ticker.first
     assert_not holding.save, "saved without an Account"
   end
end

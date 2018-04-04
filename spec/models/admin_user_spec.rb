require "rails_helper"
RSpec.describe AdminUser, :type => :model do
  before(:all) do
    @user1 = AdminUser.first
  end

  it 'is valid with valid attributes' do
    expect(@user1).to be_valid
  end

  it 'has a unique email' do
    user2 = build(:admin_user, email: @user1.email)
    expect(user2).to_not be_valid
  end

  it 'equity_value is 0 if user has no accounts' do
    expect(@user1.equity_value).to eq(0)
  end

  it 'total_value is 0 if user has no accounts' do
    expect(@user1.total_value).to eq(0)
  end

  it 'cash is 0 if user has no accounts' do
    expect(@user1.cash).to eq(0)
  end

  
end

class Holding < ActiveRecord::Base
  require_dependency 'amounts'
  include Amounts
  belongs_to :account
  belongs_to :ticker
  has_many :prices, through: :ticker
  delegate :symbol, :description, :maturity, :duration, :expenses, :quality, :group, to: :ticker, prefix: false, allow_nil: true
  #  validates_presence_of :account_id, :ticker_id
  validates_presence_of :ticker_id
  after_save :update_account

  def update_account
    account.update_values
  end
    
  def admin_user
    account.admin_user
  end
  def cost
    shares * purchase_price + commissions
  end

  def value
    shares * price.to_f
  end

  def price
    if self.ticker
      self.ticker.last_price
    else
      0
    end
  end
  #
  #  Need to add commissions at some point
  #  For now ignore
  #
  def commissions
    0
  end
end

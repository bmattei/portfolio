class Holding < ApplicationRecord
  # in lib
  require_dependency 'amounts'
  include Amounts
  belongs_to :account
  belongs_to :ticker
  has_many :prices, through: :ticker
  delegate :symbol, :name, :description, :maturity, :duration, :expenses, :quality, :group, to: :ticker, prefix: false, allow_nil: true
  delegate :brokerage, to: :account, prefix: false
  delegate :brokerage, :name, to: :account, prefix: true
  # Problem in add acocunt with holdings if account_id is validated.
  # validates_presence_of :account_id
  validates_presence_of  :ticker_id
  after_save :after_save

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
  def price_date
    self.ticker.last_price_date
  end
      
  #
  #  Need to add commissions at some point
  #  For now ignore
  #
  def commissions
    0
  end

  private
  def after_save
    if self.shares == 0
      self.destroy
    elsif !self.price
      self.ticker.retrieve_price
    end
  end

end

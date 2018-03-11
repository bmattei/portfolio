class Holding < ActiveRecord::Base
  require_dependency 'category_split'
  include CategorySplit
  belongs_to :account
  belongs_to :ticker
  has_many :prices, through: :ticker
  delegate :symbol, :description, :maturity, :duration, :expenses, :quality, :group, to: :ticker, prefix: false, allow_nil: true
  has_many :category_tickers, through: :ticker
  has_many :categories, through: :category_tickers

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

class Capture < ApplicationRecord
  has_many :snapshots

  def self.capture
    c = Capture.create(cash: Account.cash)
    Holding.all.each do |h|
      if h.shares > 0
        c.snapshots.create(ticker_id: h.ticker_id,
                           price: h.price,
                           account_id: h.account_id,
                           shares: h.shares)
      end
    end
  end
  def self.retrieve_and_capture
    Ticker.retrieve_prices
  end
  def holdings_value
    snapshots.inject(0) {|sum, n| sum + n.value}
  end
  def total_value
    self.holdings_value + self.cash
  end
  def category_value(cat_selector)
    snapshots.inject(0) { |sum, h| sum + h.category_value(cat_selector) }
  end
def equity_value
    category_value(base_type: :equity)
  end
  def foreign_equity
    category_value(base_type: :equity, domestic: false)
  end
  def domestic_equity
    category_value(base_type: :equity, domestic: true)
  end
  def bond_value
    category_value(base_type: :bond)
  end
  def other_value
    total_value - ( bond_value + equity_value + cash.to_f)
  end
  def large_cap()
    category_value(base_type: :equity, size: :largeCap)
  end
  def small_cap()
    category_value(base_type: :equity, size: :smallCap)
  end
  def mid_cap()
    category_value(base_type: :equity, size: :midCap)
  end
  def cash_value()
    category_value(base_type: :cash)
  end
  
end

class Holding < ApplicationRecord
  # in lib
  require_dependency 'amounts'
  include Amounts
  belongs_to :account
  belongs_to :ticker
  has_many :prices, through: :ticker
  # delegate :symbol, :name, :description, :maturity, :duration, :expenses, :quality, :group,
  #          :aa_us_stock, :aa_non_us_stock, :aa_bond, :bs_government, :gov_nominal,:gov_tips,
  #          :aa_cash, :aa_other, :quality, :cq_aaa, :cq_aa, :cq_a, :cq_bbb, :cq_bb, :cq_b,
  #          to: :ticker, prefix: false, allow_nil: true
  delegate :brokerage, to: :account, prefix: false
  delegate :brokerage, :name, to: :account, prefix: true
  # Problem in add acocunt with holdings if account_id is validated.
  # validates_presence_of :account_id
  validates_presence_of  :ticker_id
  after_save :after_save

  def method_missing(m, *args, &block)
    self.ticker.send(m)
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

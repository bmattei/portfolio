class AdminUser < ActiveRecord::Base
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable
  has_many :accounts, dependent: :destroy
  has_many :holdings, through: :accounts
  # has_many :tickers,  through: :holdings
  has_many :captures, dependent: :destroy

  def new_capture
    ticker_list = self.tickers.collect {|h| h.symbol }
    Ticker.retrieve_prices(ticker_list)
    c = self.captures.create(cash: self.free_cash)
    self.holdings.each do |h|
      c.snapshots.create(ticker_id: h.ticker_id,
                         price: h.price,
                         account_id: h.account_id,
                         shares: h.shares)
    end
    c.save
  end

  def tickers
    self.holdings.collect {|x| x.ticker}.uniq
  end
  def free_cash
    accounts.inject(0) {|sum, n| sum +  n.cash }
  end
  def equity_value
    accounts.inject(0) {|sum, n| sum +  n.equity_value }
  end  
  def total_value()
    accounts.inject(0) {|sum, n| sum +  (n.total_value || 0) }
  end
  def summary_info
    summary_info = []
    total_value = total_value()

    tickers.uniq.each do |t|
      total = t.holdings.inject(0) { |sum, n| sum + n.value }.to_f
      summary_info << OpenStruct.new(symbol: t.symbol,
                                     description: t.description,
                                     expenses: t.expenses,
                                     shares: t.holdings.sum(:shares).to_f,
                                     price:  t.holdings.first.price.to_f,
                                     value:  total,
                                     us_equity: t.aa_us_stock.to_f,
                                     foreign_equity: t.aa_non_us_stock.to_f,
                                     bond: t.aa_bond.to_f,
                                     other: t.aa_other.to_f,
                                     cash: t.aa_cash.to_f,
                                     percent: (total / total_value),
                                    )
    end
    total_cash =  accounts.inject(0) {|sum, a| sum + a.cash}
    summary_info << OpenStruct.new(symbol: "CASH",
                                   shares: nil,
                                   price: nil,
                                   value: total_cash,
                                   percent: total_value > 0 ? (total_cash/total_value) :  0,
                                   cash: 1
                                  )
    
    
  end
  def segment_amount(segment)
    accounts.inject(0) {|sum, n| sum +  n.segment_amount(segment) }
  end
end

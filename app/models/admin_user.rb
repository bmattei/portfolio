class AdminUser < ActiveRecord::Base
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable
  has_many :accounts, dependent: :destroy
  has_many :holdings, through: :accounts
  has_many :tickers,  through: :holdings
  has_many :captures, dependent: :destroy
  accepts_nested_attributes_for :holdings, allow_destroy: true
  def new_capture
    c = self.captures.create(cash: self.free_cash)
    self.holdings.each do |h|
      if h.shares > 0
        c.snapshots.create(ticker_id: h.ticker_id,
                           price: h.price,
                           account_id: h.account_id,
                           shares: h.shares)
      end
    end
    c.save
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
                                     equity: (t.aa_us_stock) + t.aa_non_us_stock * 100,
                                     foreign_equity: t.aa_non_us_stock * 100,
                                     bond: t.aa_bond * 100,
                                     percent: (total / total_value) * 100,
                                     fund_cash: t.aa_cash * 100
                                    )
    end
    total_cash =  accounts.inject(0) {|sum, a| sum + a.cash}
    summary_info << OpenStruct.new(symbol: "CASH",
                                   shares: nil,
                                   price: nil,
                                   value: total_cash,
                                   percent: total_value > 0 ? (total_cash/total_value) * 100 :  0
                                  )
    
    
  end
  def segment_amount(segment)
    accounts.inject(0) {|sum, n| sum +  n.segment_amount(segment) }
  end
end

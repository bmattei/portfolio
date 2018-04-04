class AdminUser < ActiveRecord::Base
    devise :database_authenticatable, 
           :recoverable, :rememberable, :trackable, :validatable
    has_many :accounts, dependent: :destroy
    has_many :holdings, through: :accounts
    has_many :tickers,  through: :holdings
    has_many :captures, dependent: :destroy

    def new_capture
      c = self.captures.create(cash: self.cash)
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
                                          equity: t.value_percent(base_type: :equity) * 100,
                                          foreign_equity: t.value_percent(base_type: :equity,
                                                                          domestic: false) * 100,
                                          bond: t.value_percent(base_type: :bond) * 100,
                                          percent: (total / total_value) * 100
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


  
  def equity_value
    accounts.inject(0) {|sum, n| sum +  n.equity_value }
  end
  def foreign_value
    accounts.inject(0) {|sum, n| sum +  n.foreign_equity }
  end
  def domestic_value
    accounts.inject(0) {|sum, n| sum +  n.domestic_equity }
  end
  def bond_value
    accounts.inject(0) {|sum, n| sum +  n.bond_value }
  end
  def cash
    accounts.inject(0) {|sum, n| sum +  n.cash }
  end
  def other_value
    total_value -
      ( bond_value +
        equity_value +
        cash)
  end
  def large_cap
    accounts.inject(0) {|sum, acc| sum +  acc.large_cap }
  end
  def small_cap
    accounts.inject(0) {|sum, acc|  sum +  acc.small_cap }
  end
  def category_value(cat_selector)
    
    accounts.inject(0) { |sum, n | sum + n.category_value(cat_selector) }
  end
end

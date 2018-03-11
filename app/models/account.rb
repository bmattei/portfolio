class Account < ActiveRecord::Base
  Etrade = "etrade"
  Fidelity = "Fidelity"
  
  belongs_to :admin_user
  belongs_to :account_type
  has_many   :holdings
  accepts_nested_attributes_for :holdings
  before_save :update_values_no_save


  def self.total_value
    Account.all.inject(0) {|sum, n| sum +  n.total_value }
  end
  def self.summary_info
    summary_info = []
    total_value = Account.total_value
    Ticker.all.each do |t|
      if t.holdings.count > 0
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
    end
    total_cash =  Account.all.inject(0) {|sum, a| sum + a.cash}
    summary_info << OpenStruct.new(symbol: "CASH",
                                   shares: nil,
                                   price: nil,
                                   value: total_cash,
                                   percent: (total_cash/total_value) * 100
                                  )


  end

  def self.equity_value
    Account.all.inject(0) {|sum, n| sum +  n.equity_value }
  end
  def self.foreign_value
    Account.all.inject(0) {|sum, n| sum +  n.foreign_equity }
  end
  def self.domestic_value
    Account.all.inject(0) {|sum, n| sum +  n.domestic_equity }
  end
  def self.bond_value
    Account.all.inject(0) {|sum, n| sum +  n.bond_value }
  end
  def self.cash
    Account.all.inject(0) {|sum, n| sum +  n.cash }
  end
  def self.other_value
    Account.total_value - ( Account.bond_value + Account.equity_value + Account.cash.to_f)
  end
  def self.large_cap
    Account.all.inject(0) {|sum, n| sum +  n.large_cap }
  end
  def self.small_cap()
    Account.all.inject(0) {|sum, n| sum +  n.small_cap }
  end
  def self.category_value(cat_selector)
    Account.all.inject(0) { |sum, n | sum + n.category_value(cat_selector) }
  end
  def mid_cap()
    Account.all.inject(0) {|sum, n| sum +  n.mid_cap }
  end
  def category_value(cat_selector)
    holdings.inject(0) { |sum, h| sum + h.category_value(cat_selector) }
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
  def category_value(cat_selector)
    holdings.inject(0) { |sum, h| sum + h.category_value(cat_selector) }
  end


  def calc_holdings_value
    holdings.inject(0) {|sum, n | sum + n.value }
  end
  def cash
    self[:cash] || 0
  end

  def update_values_no_save
    self.holdings_value = self.calc_holdings_value
    self.total_value = self.holdings_value.to_f + self.cash.to_f
  end
  def update_values
    self.update_values_no_save
    self.save
  end
  
  
end

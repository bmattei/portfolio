class Account < ActiveRecord::Base
  Etrade = "etrade"
  Fidelity = "Fidelity"
  
  belongs_to :admin_user
  belongs_to :account_type
  has_many   :holdings, dependent: :destroy
  accepts_nested_attributes_for :holdings
  before_save :update_values_no_save
  after_create :update_values

  def mid_cap(admin_user_id)
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

  def calc_holdings_value
    holdings.inject(0) {|sum, n | sum + n.value }
  end
  def cash
    self[:cash] || 0
  end
  def total_value
    if !self[:total_value]
      update_values
    end
    self[:total_value]
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

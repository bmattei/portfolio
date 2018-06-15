class Account < ActiveRecord::Base
  Etrade = "etrade"
  Fidelity = "Fidelity"
  
  belongs_to :admin_user
  belongs_to :account_type
  has_many   :holdings, dependent: :destroy
  accepts_nested_attributes_for :holdings

   
  after_update :update_values_no_save
  # before_save :update_values_no_save
  # after_create :update_values

  def segment_amount(segment)
    if !segment.to_s.ends_with?('_amount')
      segment = segment.to_s + '_amount'
    end
    holdings.inject(0) {|sum, n| sum + n.send(segment) }
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

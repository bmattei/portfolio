class Earning < ApplicationRecord
  belongs_to :admin_user
  def adjusted_earnings
    ss = SsFactor.where(year: self.year).first 
    amount = self.amount > ss.max_earnings ? ss.max_earnings : (self.amount || 0)
    amount * ss.factor
  end
  def ss_tax
    ss_info = SsFactor.where(year: self.year).first
    amount = [self.amount, ss_info.max_earnings].min
    ss_info.ss_tax_rate * amount
  end
  def ss_tax_current
    ss_info = SsFactor.where(year: self.year).first
    ss_tax * ss_info.factor
  end
   
end

class Earning < ApplicationRecord
  belongs_to :user
  def adjusted_earnings
    ss = SsFactor.where(year: self.year).first 
#    amount = self.amount > ss.max_earnings ? ss.max_earnings : (self.amount || 0)
    self.amount * ss.factor
  end
  def ss_tax
    puts "-----------earnings tax year #{self.year}"
    ss_info = SsFactor.where(year: self.year).first
#    amount = [self.amount, ss_info.max_earnings].min
    ss_info.ss_tax_rate * self.amount
  end
  def ss_tax_current
    ss_info = SsFactor.where(year: self.year).first
    puts "\n\n\n*************************\n\n"
    pp self.year
    ss_tax * ss_info.factor
  end
  def admin_user
    user.admin_user
  end
   
end

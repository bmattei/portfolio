# coding: utf-8
class User < ApplicationRecord
  has_many :earnings
  # Step 1: Enter your earnings in Column B, but not more than the
  # amount shown in Column A. If you have no earnings, enter “0.”
  # Step 2: Multiply the amounts in Column B by the index factors
  # in Column C, and enter the results in Column D. This gives you
  # your indexed earnings, or the estimated value of your earnings
  # in current dollars.
  # Step 3: Choose from Column D the 35 years with the highest
  # amounts. Add these amounts. $_________
  # Step 4: Divide the result from Step 3 by 420 (the number of
  # months in 35 years). Round down to the next lowest dollar.
  # This will give you your average indexed monthly earnings.
  # $_________
  # Step 5:
  # a. Multiply the first $885 in Step 4 by 90%. $_________
  # b. Multiply the amount in Step 4 over $885, and less than or
  # equal to $5,336, by 32%. $_________
  # c. Multiply the amount in Step 4 over $5,336 by 15%.
  # $_________
  # Step 6: Add a, b, and c from Step 5. Round down to the next
  # lowest dollar. This is your estimated monthly retirement benefit
  # at age 66 and 2 months, your full retirement age. $_________
  # Step 7: Multiply the amount in Step 6 by 74.167%.
  # This is your estimated monthly retirement benefit if you retire at
  # age 62. $_________

  def name
    self.first_name + " " + self.last_name
  end
  def ss_contribution
    self.earnings.inject(0) {|sum, x|  sum + (2 * x.ss_tax_current) }
  end
  def top_35
    earnings.collect {|x| x.adjusted_earnings}.sort {|a,b| b <=>a}.slice(0..34)
  end
  def sum_top_35
    top_35.inject(0) { |sum, n| sum + n }
  end
  def avg_monthly
    (sum_top_35/420).floor
  end
  def ss_at_full_retirement
    avg  = avg_monthly
    factor_90 = [885, avg].min
    factor_32 = [[avg_monthly, 5336].min - 885, 0].max
    factor_15 = [avg_monthly - 5336, 0].max
    factor_90 * 0.9 + factor_32 * 0.32 + factor_15 * 0.15
  end
  def birth_year
    date_of_birth.year
  end
  def full_ss_age
    (full_retirement_months/12).to_s + " yrs  " + (full_retirement_months.modulo(12)).to_s + " mons "
  end
  def full_retirement_months
   SsAdjustment.where('start_year <= ? and end_year >= ?',  birth_year, birth_year).first.full_retirement_months
  end 
  def ss_at_70
    num_months = (12 * 70) - full_retirement_months
    full_retirement = ss_at_full_retirement
    full_retirement * (1 + num_months * SsAdjustment::MONTHLY_INCREASE)
  end
  def ss_at_62
    num_months = full_retirement_months - (62 * 12)
    total_adjustment = SsAdjustment::MONTHLY_DECREASE_FIRST_36 * 36 + SsAdjustment::MONTHLY_DECREASE_OVER_36 * (num_months - 36)
    full_retirement = ss_at_full_retirement
    full_retirement * (1 - total_adjustment)
  end
  
  end

# coding: utf-8
class User < ApplicationRecord
  belongs_to :admin_user
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

  attr_accessor :retirement_age_in_years, :retirement_age_in_months
  def name
    self.first_name + " " + self.last_name
  end
  def ss_contribution
    if self.earnings.count > 0
      self.earnings.inject(0) {|sum, x|  sum + (2 * x.ss_tax_current) }
    end
  end
  def top_35
    if self.earnings.count > 0
      earnings.collect {|x| x.adjusted_earnings}.sort {|a,b| b <=>a}.slice(0..34)
    end
  end
  def sum_top_35
    if self.earnings.count > 0
      top_35.inject(0) { |sum, n| sum + n }
    end
  end
  def avg_monthly
    if self.earnings.count > 0
      (sum_top_35/420).floor
    end
  end
  
  def birth_year
    date_of_birth.year
  end
  def full_ss_age
    if self.earnings.count > 0
      (full_retirement_months/12).to_s + " yrs  " + (full_retirement_months.modulo(12)).to_s + " mons "
    end
  end
  def ss_at_62
    if self.earnings.count > 0
      num_months = full_retirement_months - (62 * 12)
      total_adjustment = SsAdjustment::MONTHLY_DECREASE_FIRST_36 * 36 + SsAdjustment::MONTHLY_DECREASE_OVER_36 * (num_months - 36)
      full_retirement = ss_at_full_retirement
      full_retirement * (1 - total_adjustment)
    end
  end
  def full_retirement_months
    if self.earnings.count > 0
      SsAdjustment.where('start_year <= ? and end_year >= ?',  birth_year, birth_year).first.full_retirement_months
    end
  end
  def ss_at_full_retirement
    if self.earnings.count > 0
      avg  = avg_monthly
      factor_90 = [885, avg].min
      factor_32 = [[avg_monthly, 5336].min - 885, 0].max
      factor_15 = [avg_monthly - 5336, 0].max
      factor_90 * 0.9 + factor_32 * 0.32 + factor_15 * 0.15
    end
  end
  def ss_at_70
    if self.earnings.count > 0
      num_months = (12 * 70) - full_retirement_months
      full_retirement = ss_at_full_retirement
      full_retirement * (1 + num_months * SsAdjustment::MONTHLY_INCREASE)
    end
  end

  def ss_at_age(years, months = 0)
    monthly_ss = nil
    age_in_months = 12 * years + months
    if age_in_months <= (70 * 12) && age_in_months >= (62 * 12) 
      monthly_ss =
        case 
        when age_in_months < full_retirement_months
          ss_age_less_than_full(age_in_months)
        when age_in_months == full_retirement_months
          ss_at_full_retirment
        when age_in_months > full_retirement_months
          ss_age_greater_than_full(age_in_months)
        end
    end
    monthly_ss
  end

  private
  def ss_age_less_than_full(age_in_months)
    num_months = full_retirement_months - age_in_months
    total_adjustment = SsAdjustment::MONTHLY_DECREASE_FIRST_36 * [age_in_months, 36].min +
                       SsAdjustment::MONTHLY_DECREASE_OVER_36 * [num_months - 36, 0].max
    full_retirement = ss_at_full_retirement
    full_retirement * (1 - total_adjustment)
  end

  def ss_age_greater_than_full(age_in_months)
    num_months = age_in_months - full_retirement_months
    full_retirement = ss_at_full_retirement
    full_retirement * (1 + num_months * SsAdjustment::MONTHLY_INCREASE)
  end

end


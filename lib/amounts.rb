module Amounts
  def bond_amount
    value * ticker.aa_bond.to_f
  end
  def stock_amount
    us_stock_amount + non_us_stock_amount.to_f
  end
  def us_stock_amount
    value * ticker.aa_us_stock.to_f
  end
  def non_us_stock_amount
    value * ticker.aa_non_us_stock.to_f
  end
  def other_amount
    value * ticker.aa_other.to_f
  end
  def cash_amount
    value * ticker.aa_cash.to_f
  end

  def cap_giant_amount
    stock_amount * ticker.cap_giant.to_f
  end
  def cap_giant_amount
    stock_amount * ticker.cap_giant.to_f
  end
  def cap_large_amount
    stock_amount * ticker.cap_large.to_f
  end
  def cap_medium_amount
    stock_amount * ticker.cap_medium.to_f
  end
  def cap_small_amount
    stock_amount * ticker.cap_small.to_f
  end
  def cap_micro_amount
    stock_amount * ticker.cap_micro.to_f
  end

  def basic_material_amount
    stock_amount * ticker.ss_basic_material.to_f
  end
  def consumer_cyclical_amount
    stock_amount * ticker.ss_consumer_cyclical.to_f
  end
  def financial_services_amount
    stock_amount * ticker.ss_financial_services.to_f
  end
  def realestate_amount
    stock_amount * ticker.ss_realestate.to_f
  end
  def communications_services_amount
    stock_amount * ticker.ss_communications_services.to_f
  end
  def energy_amount
    stock_amount * ticker.ss_energy.to_f
  end
  def industrials_amount
    stock_amount * ticker.ss_industrials.to_f
  end
  def technology_amount
    stock_amount * ticker.ss_technology.to_f
  end
  def consumer_defensive_amount
    stock_amount * ticker.ss_consumer_defensive.to_f
  end
  def healthcare_amount
    stock_amount * ticker.ss_healthcare.to_f
  end
  def utilities_amount
    stock_amount * ticker.ss_utilities.to_f
  end
  
  def americas_amount
    stock_amount * ticker.mr_americas.to_f
  end
  def greater_europe_amount
    stock_amount * ticker.mr_greater_europe.to_f
  end
  def greater_asia_amount
    stock_amount * ticker.mr_greater_asia.to_f
  end

  def developed_amount
    stock_amount * ticker.mc_developed.to_f
  end
  def emerging_amount
    stock_amount * ticker.mc_emerging.to_f
  end

  def government_amount
    bond_amount * ticker.bs_government.to_f
  end
  def corporate_amount
    bond_amount * ticker.bs_corporate.to_f
  end
  def securitized_amount
    bond_amount * ticker.bs_securitized.to_f
  end
  def municipal_amount
    bond_amount * ticker.bs_municipal.to_f
  end
  def other_bond_amount
    bond_amount * ticker.bs_other.to_f
  end
  def gov_tips_amount
    bond_amount * ticker.gov_tips.to_f
  end
  def gov_nominal_amount
    bond_amount * ticker.gov_nominal.to_f
  end
  def cq_aaa_amount
    bond_amount * ticker.cq_aaa.to_f
  end
  def cq_aa_amount
    bond_amount * ticker.cq_aa.to_f
  end
  def cq_a_amount
    bond_amount * ticker.cq_a.to_f
  end
  def cq_bbb_amount
    bond_amount * ticker.cq_bbb.to_f
  end
  def cq_bb_amount
    bond_amount * ticker.cq_bb.to_f
  end
  def cq_b_amount
    bond_amount * ticker.cq_b.to_f
  end
  def cq_below_b_amount
    bond_amount * ticker.cq_below_b.to_f
  end
  def cq_not_rated_amount
    bond_amount * ticker.cq_not_rated.to_f
  end

  def bond_cash_amount
    bond_amount * ticker.bs_cash.to_f
  end
  def government_amount
    bond_amount * ticker.bs_government.to_f
  end
  def corporate_amount
    bond_amount * ticker.bs_corporate.to_f
  end
  def securitized_amount
    bond_amount * ticker.bs_securitized.to_f
  end
  def municipal_amount
    bond_amount * ticker.bs_municipal.to_f
  end
  def bond_other_amount
    bond_amount * ticker.bs_other.to_f
  end

end

module ActiveAdmin::ViewHelper
  def holding_allocation(total)
    dollar_hash = {:display_as => :dollar}
    percent_hash = {:display_as => :percent}
    summary_info = current_admin_user.summary_info
    summary_info.each do |h|
      dollar_hash[h.symbol] = h.value
      percent_hash[h.symbol] = h.percent
    end
    dollar_struct = OpenStruct.new(dollar_hash)
    percent_struct = OpenStruct.new(percent_hash)
    holding_allocation = [
      percent_struct,
      dollar_struct,

    ]


  end
  def segment_allocation(total)
    dollar_struct =       OpenStruct.new(
        display_as: :dollar,
        stock: current_admin_user.segment_amount(:stock),
        us_stock: current_admin_user.segment_amount(:us_stock),
        non_us_stock: current_admin_user.segment_amount(:non_us_stock),
        bond: current_admin_user.segment_amount(:bond),
        other: current_admin_user.segment_amount(:other),
        holdings_cash: current_admin_user.segment_amount(:cash),
        cap_giant: current_admin_user.segment_amount(:cap_giant),
        cap_large: current_admin_user.segment_amount(:cap_large),
        cap_medium: current_admin_user.segment_amount(:cap_medium),
        cap_small: current_admin_user.segment_amount(:cap_small),
        cap_micro: current_admin_user.segment_amount(:cap_micro),
        basic_material: current_admin_user.segment_amount(:basic_material),
        consumer_cyclical: current_admin_user.segment_amount(:consumer_cyclical),
        financial_services: current_admin_user.segment_amount(:financial_services),
        realestate: current_admin_user.segment_amount(:realestate),
        communications_services: current_admin_user.segment_amount(:communications_services),
        energy: current_admin_user.segment_amount(:energy),
        industrials: current_admin_user.segment_amount(:industrials),
        technology: current_admin_user.segment_amount(:technology),
        consumer_defensive: current_admin_user.segment_amount(:consumer_defensive),
        healthcare: current_admin_user.segment_amount(:healthcare),
        utilities: current_admin_user.segment_amount(:utilities),
        americas: current_admin_user.segment_amount(:americas),
        greater_europe: current_admin_user.segment_amount(:greater_europe),
        greater_asia: current_admin_user.segment_amount(:greater_asia),
        developed: current_admin_user.segment_amount(:developed),
        emerging: current_admin_user.segment_amount(:emerging),
        government: current_admin_user.segment_amount(:government),
        corporate: current_admin_user.segment_amount(:corporate),
        securitized: current_admin_user.segment_amount(:securitized),
        municipal: current_admin_user.segment_amount(:municipal),
        bond_other: current_admin_user.segment_amount(:bond_other),
        bond_cash: current_admin_user.segment_amount(:bond_cash),
        gov_tips: current_admin_user.segment_amount(:gov_tips),
        gov_nominal: current_admin_user.segment_amount(:gov_nominal),
        cq_aaa: current_admin_user.segment_amount(:cq_aaa),
        cq_aa: current_admin_user.segment_amount(:cq_aa),
        cq_a: current_admin_user.segment_amount(:cq_a),
        cq_bbb: current_admin_user.segment_amount(:cq_bbb),
        cq_bb: current_admin_user.segment_amount(:cq_bb),
        cq_b: current_admin_user.segment_amount(:cq_b),
        cq_below_b: current_admin_user.segment_amount(:cq_below_b),
        cq_not_rated: current_admin_user.segment_amount(:cq_not_rated),
        free_cash: current_admin_user.free_cash(),
        total: current_admin_user.total_value()
      )
      
      percent_struct = OpenStruct.new(display_as: :percent)
      total_segments = [:stock, :us_stock, :non_us_stock, :bond, :other, :holdings_cash, :free_cash,
                        :total]
      stock_segments = [:cap_giant, :cap_large, :cap_medium, :cap_small, :cap_micro,
                        :basic_material,:consumer_cyclical,:financial_services,
                        :realestate,  :communications_services,:energy, :industrials,
                        :technology,:consumer_defensive,:healthcare,:utilities,:americas,
                        :greater_europe,:greater_asia, :developed,  :emerging
                       ]
      bond_segments = [ :government, :corporate, :securitized, :municipal,
                        :bond_other, :bond_cash, :gov_tips,  :gov_nominal, :cq_aaa,
                        :cq_aa, :cq_a, :cq_bbb, :cq_bb, :cq_b, :cq_below_b,
                        :cq_not_rated
                      ]
      dollar_struct.each_pair do  |k,v|
        if total_segments.include?(k)
          percent_struct[k] = (v / total) * 100 
        elsif stock_segments.include?(k)
          percent_struct[k] = (v / dollar_struct[:stock]) * 100
        elsif bond_segments.include?(k)
          percent_struct[k] = (v / dollar_struct[:bond]) * 100
        end
      end
      allocation = [
        percent_struct,
        dollar_struct,
      ]
    end

  end

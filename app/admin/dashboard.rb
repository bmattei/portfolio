ActiveAdmin.register_page "Dashboard" do

  menu priority: 90, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    equity = current_admin_user.equity_value()
    bond = current_admin_user.bond_value()
    cash = current_admin_user.cash()
    total = current_admin_user.total_value()
    other = current_admin_user.other_value()

    domestic = current_admin_user.category_value( base_type: :equity, domestic: true)
    domestic_large = current_admin_user.category_value( base_type: :equity, reit: false, domestic: true, size: :largeCap)
    domestic_mid = current_admin_user.category_value( base_type: :equity, reit: false, domestic: true, size: :midCap)
    domestic_small = current_admin_user.category_value( base_type: :equity, reit: false, domestic: true, size: :smallCap)

    domestic_reit = current_admin_user.category_value( base_type: :equity, reit: true, domestic: true)

    foreign_reit =  current_admin_user.category_value( base_type: :equity, reit: true, domestic: false)



    foreign = current_admin_user.category_value( base_type: :equity, domestic: false)
    foreign_large = current_admin_user.category_value( base_type: :equity, reit: false, domestic: false, size: :largeCap)
    foreign_mid = current_admin_user.category_value( base_type: :equity, reit: false, domestic: false, size: :midCap)
    foreign_small = current_admin_user.category_value( base_type: :equity, reit: false, domestic: false, size: :smallCap)

    foreign_developed  = current_admin_user.category_value( base_type: :equity, domestic: false, emerging: false)
    foreing_developed_large = current_admin_user.category_value( base_type: :equity, domestic: false, emerging: false, size: :largeCap)
    foreign_developed_mid = current_admin_user.category_value( base_type: :equity, domestic: false, emerging: false, size: :midCap)
    foreign_developed_small = current_admin_user.category_value( base_type: :equity, domestic: false, emerging: false, size: :smallCap)

    foreign_emerging = current_admin_user.category_value( base_type: :equity, domestic: false, emerging: true)
    foreing_emerging_large = current_admin_user.category_value( base_type: :equity, domestic: false, emerging: true, size: :largeCap)
    foreing_emerging__mid = current_admin_user.category_value( base_type: :equity, domestic: false, emerging: true, size: :midCap)
    foreing_emerging_small = current_admin_user.category_value( base_type: :equity, domestic: false, emerging: true, size: :smallCap)

    nominal = current_admin_user.category_value( base_type: :bond, inflation_adjusted: false)
    nominal_long = current_admin_user.category_value( base_type: :bond, duration: :long, inflation_adjusted: false)
    nominal_intermediate = current_admin_user.category_value( base_type: :bond, duration: :intermediate, inflation_adjusted: false)
    nominal_short = current_admin_user.category_value( base_type: :bond, duration: :short, inflation_adjusted: false)

    tip = current_admin_user.category_value( base_type: :bond, inflation_adjusted: true)
    tip_long = current_admin_user.category_value( base_type: :bond, duration: :long, inflation_adjusted: true)
    tip_intermediate = current_admin_user.category_value( base_type: :bond, duration: :intermediate, inflation_adjusted: true)
    tip_short = current_admin_user.category_value( base_type: :bond, duration: :short, inflation_adjusted: true)

    
    allocation = [
      OpenStruct.new(
        display_as: :percent,
        equity: (total > 0 ? (equity * 100)/total : 0) ,
        bond: (total > 0 ? (bond * 100)/total : 0) ,
        cash: (total > 0 ? (cash * 100)/total : 0) ,
        other: (total > 0 ? (other * 100)/total : 0) ,
        domestic: (total > 0 ? (domestic * 100)/total : 0) ,
        domestic_large: (total > 0 ? (domestic_large * 100)/total : 0) ,
        domestic_mid: (total > 0 ? (domestic_mid * 100)/total : 0) ,
        domestic_small: (total > 0 ? (domestic_small * 100)/total : 0) ,
        domestic_non_reit: (total > 0 ? ((domestic - domestic_reit) * 100)/total : 0),
        domestic_reit: (total > 0 ? (domestic_reit * 100)/total : 0) ,
        foreign: (total > 0 ? (foreign * 100)/total : 0) ,
        foreign_large: (total > 0 ? (foreign_large * 100)/total : 0) ,
        foreign_mid: (total > 0 ? (foreign_mid * 100)/total : 0) ,
        foreign_small: (total > 0 ? (foreign_small * 100)/total : 0) ,
        foreign_reit: (total > 0 ? (foreign_reit * 100)/total : 0) ,
        foreign_developed: (total > 0 ? (foreign_developed * 100)/total : 0) ,
        foreign_emerging: (total > 0 ? (foreign_emerging * 100)/total : 0) ,
        nominal: (total > 0 ? (nominal * 100)/total : 0) ,
        nominal_long: (total > 0 ? (nominal_long * 100)/total : 0) ,
        nominal_intermediate: (total > 0 ? (nominal_intermediate * 100)/total : 0) ,
        nominal_short: (total > 0 ? (nominal_short * 100)/total : 0) ,
        tip: (total > 0 ? (tip * 100)/total : 0) ,
        tip_long: (total > 0 ? (tip_long * 100)/total : 0) ,
        tip_intermediate: (total > 0 ? (tip_intermediate * 100)/total : 0) ,
        tip_short: (total > 0 ? (nominal_short * 100)/total : 0) ,
        total: 100),
      
      OpenStruct.new(
        display_as: :dollar,
        equity: equity,
        bond: bond,
        cash:  cash,
        other: other,
        domestic: domestic,
        domestic_large: domestic_large,
        domestic_mid: domestic_mid,
        domestic_small: domestic_small,
        domestic_non_reit: domestic - domestic_reit,
        domestic_reit: domestic_reit,
        foreign: foreign,
        foreign_large: foreign_large,
        foreign_mid: foreign_mid,
        foreign_small: foreign_small,
        foreign_reit: foreign_reit,
        foreign_developed: foreign_developed,
        foreign_emerging: foreign_emerging,
        nominal: nominal,
        nominal_long: nominal_long,
        nominal_intermediate: nominal_intermediate,
        nominal_short: nominal_short,
        tip: tip,
        tip_long: tip_long,
        tip_intermediate: tip_intermediate,
        tip_short: tip_short,
        total: total ),
    ]

    total_no_cash = total - cash
    allocation_no_cash = [
      OpenStruct.new(
        display_as: :percent,
        equity: (total_no_cash > 0 ? (equity * 100)/total_no_cash : 0) ,
        bond: (total_no_cash > 0 ? (bond * 100)/total_no_cash : 0) ,
        other: (total_no_cash > 0 ? (other * 100)/total_no_cash : 0) ,
        domestic: (total_no_cash > 0 ? (domestic * 100)/total_no_cash : 0) ,
        domestic_large: (total_no_cash > 0 ? (domestic_large * 100)/total_no_cash : 0) ,
        domestic_mid: (total_no_cash > 0 ? (domestic_mid * 100)/total_no_cash : 0) ,
        domestic_small: (total_no_cash > 0 ? (domestic_small * 100)/total_no_cash : 0) ,
        domestic_non_reit: (total_no_cash > 0 ? ((domestic - domestic_reit) * 100)/total_no_cash : 0),
        domestic_reit: (total_no_cash > 0 ? (domestic_reit * 100)/total_no_cash : 0) ,
        foreign: (total_no_cash > 0 ? (foreign * 100)/total_no_cash : 0) ,
        foreign_large: (total_no_cash > 0 ? (foreign_large * 100)/total_no_cash : 0) ,
        foreign_mid: (total_no_cash > 0 ? (foreign_mid * 100)/total_no_cash : 0) ,
        foreign_small: (total_no_cash > 0 ? (foreign_small * 100)/total_no_cash : 0) ,
        foreign_reit: (total_no_cash > 0 ? (foreign_reit * 100)/total_no_cash : 0) ,
        foreign_developed: (total_no_cash > 0 ? (foreign_developed * 100)/total_no_cash : 0) ,
        foreign_emerging: (total_no_cash > 0 ? (foreign_emerging * 100)/total_no_cash : 0) ,
        nominal: (total_no_cash > 0 ? (nominal * 100)/total_no_cash : 0) ,
        nominal_long: (total_no_cash > 0 ? (nominal_long * 100)/total_no_cash : 0) ,
        nominal_intermediate: (total_no_cash > 0 ? (nominal_intermediate * 100)/total_no_cash : 0) ,
        nominal_short: (total_no_cash > 0 ? (nominal_short * 100)/total_no_cash : 0) ,
        tip: (total_no_cash > 0 ? (tip * 100)/total_no_cash : 0) ,
        tip_long: (total_no_cash > 0 ? (tip_long * 100)/total_no_cash : 0) ,
        tip_intermediate: (total_no_cash > 0 ? (tip_intermediate * 100)/total_no_cash : 0) ,
        tip_short: (total_no_cash > 0 ? (nominal_short * 100)/total_no_cash : 0) ,
        total_no_cash: 100),
      
      OpenStruct.new(
        display_as: :dollar,
        equity: equity,
        bond: bond,
        other: other,
        domestic: domestic,
        domestic_large: domestic_large,
        domestic_mid: domestic_mid,
        domestic_small: domestic_small,
        domestic_non_reit: domestic - domestic_reit,
        domestic_reit: domestic_reit,
        foreign: foreign,
        foreign_large: foreign_large,
        foreign_mid: foreign_mid,
        foreign_small: foreign_small,
        foreign_reit: foreign_reit,
        foreign_developed: foreign_developed,
        foreign_emerging: foreign_emerging,
        nominal: nominal,
        nominal_long: nominal_long,
        nominal_intermediate: nominal_intermediate,
        nominal_short: nominal_short,
        tip: tip,
        tip_long: tip_long,
        tip_intermediate: tip_intermediate,
        tip_short: tip_short,
        total: total_no_cash ),
    ]

    panel "Gross Allocation" do
      table_for allocation do |x|
        column :equity , :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.equity, precision: 2)
          else
            number_to_currency i.equity
          end
        end
        column :bond , :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.bond, precision: 2)
          else
            number_to_currency i.bond
          end
        end
        column :cash , :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.cash, precision: 2)
          else
            number_to_currency i.cash
          end
        end
        column :other , :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.other, precision: 2)
          else
            number_to_currency i.other
          end
        end
        column :total , :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.total, precision: 2)
          else
            number_to_currency i.total
          end
        end
      end
      render :partial => '/admin/pie_chart',
             :locals => {allocation: [[:cash, allocation[1].cash], [:equity,  allocation[1].equity],
                                      [:bond, allocation[1].bond], [:other,  allocation[1].other]], id: 'pie-chart'}

    end


    panel "Gross Allocation No Cash" do
      table_for allocation_no_cash do |x|
        column :equity , :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.equity, precision: 2)
          else
            number_to_currency i.equity
          end
        end
        column :bond , :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.bond, precision: 2)
          else
            number_to_currency i.bond
          end
        end
        column :other , :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.other, precision: 2)
          else
            number_to_currency i.other
          end
        end
        column :total , :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.total, precision: 2)
          else
            number_to_currency i.total
          end
        end
      end
      render :partial => '/admin/pie_chart',
             :locals => {allocation: [[:equity,  allocation_no_cash[1].equity],
                                      [:bond, allocation_no_cash[1].bond], [:other,  allocation_no_cash[1].other]], id: 'pie-no-cash-chart'}

    end



    panel "Detailed" do
      table_for allocation do
        column "Domestic Equity", :domestic , :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.domestic, precision: 2)
          else
            number_to_currency i.domestic
          end
        end
        column "Foreign developed", :foreign , :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.foreign_developed, precision: 2)
          else
            number_to_currency i.foreign_developed
          end
        end
        column "Foreign Emerging", :foreign , :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.foreign_emerging, precision: 2)
          else
            number_to_currency i.foreign_emerging
          end
        end
        column "Nominal Bond", :foreign , :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.nominal, precision: 2)
          else
            number_to_currency i.nominal
          end
        end
        column "TIP", :tip , :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.tip, precision: 2)
          else
            number_to_currency i.tip
          end
        end
        column "CASH", :cash , :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.cash, precision: 2)
          else
            number_to_currency i.cash
          end
        end
        column "other", :other , :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.other, precision: 2)
          else
            number_to_currency i.other
          end
        end
      end
      render :partial => '/admin/pie_chart',
             :locals => {allocation: allocation[1].to_h.slice(:domestic, :foreign_developed, :foreign_emerging, :nominal, :tip, :cash, :other).to_a, id: 'detailed-pie-chart'}

    end

     panel "Detailed_no_cash" do
      table_for allocation_no_cash do
        column "Domestic Equity", :domestic , :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.domestic, precision: 2)
          else
            number_to_currency i.domestic
          end
        end
        column "Foreign developed", :foreign , :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.foreign_developed, precision: 2)
          else
            number_to_currency i.foreign_developed
          end
        end
        column "Foreign Emerging", :foreign , :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.foreign_emerging, precision: 2)
          else
            number_to_currency i.foreign_emerging
          end
        end
        column "Nominal Bond", :foreign , :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.nominal, precision: 2)
          else
            number_to_currency i.nominal
          end
        end
        column "TIP", :tip , :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.tip, precision: 2)
          else
            number_to_currency i.tip
          end
        end
        column "other", :other , :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.other, precision: 2)
          else
            number_to_currency i.other
          end
        end
      end
      render :partial => '/admin/pie_chart',
             :locals => {allocation: allocation_no_cash[1].to_h.slice(:domestic, :foreign_developed, :foreign_emerging, :nominal, :tip, :other).to_a, id: 'detailed-pie-chart'}

    end

    panel "Fine Detail" do
      table_for allocation do
        column "Domestic Equity (not Reit)", :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.domestic_non_reit, precision: 2)
          else
            number_to_currency i.domestic_non_reit
          end
        end
        column "Domestic Reit", :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.domestic_reit, precision: 2)
          else
            number_to_currency i.domestic_reit
          end
        end
        column "Foreign Developed Equity", :foreign , :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.foreign_developed, precision: 2)
          else
            number_to_currency i.foreign_developed
          end
        end
        column "Foreign Emerging  Equity", :foreign , :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.foreign_emerging, precision: 2)
          else
            number_to_currency i.foreign_emerging
          end
        end
        column "Nominal Long", :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.nominal_long, precision: 2)
          else
            number_to_currency i.nominal_long
          end
        end
        column "Nominal intermediate", :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.nominal_intermediate, precision: 2)
          else
            number_to_currency i.nominal_intermediate
          end
        end
        column "Nominal short", :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.nominal_short, precision: 2)
          else
            number_to_currency i.nominal_short
          end
        end
        column "Tip Long", :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.tip_long, precision: 2)
          else
            number_to_currency i.tip_long
          end
        end
        column "Tip intermediate", :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.tip_intermediate, precision: 2)
          else
            number_to_currency i.tip_intermediate
          end
        end
        column "Tip short", :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.tip_short, precision: 2)
          else
            number_to_currency i.tip_short
          end
        end
        column "CASH", :cash , :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.cash, precision: 2)
          else
            number_to_currency i.cash
          end
        end
        column "other", :other , :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.other, precision: 2)
          else
            number_to_currency i.other
          end
        end
      end
      render :partial => '/admin/pie_chart',
             :locals => {allocation: allocation[1].to_h.slice(:domestic_non_reit,
                                                              :domestic_reit,
                                                              :foreign_developed,
                                                              :foreign_emerging,
                                                              :nominal_long,
                                                              :nominal_intermediate,
                                                              :nominal_short,
                                                              :tip_long,
                                                              :tip_intermediate,
                                                              :tip_short,
                                                              :cash,
                                                              :other
                                                             ).to_a, id: 'fine-pie-chart'}

    end



    panel "Fine Detail No Cash" do
      table_for allocation_no_cash do
        column "Domestic Equity (not Reit)", :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.domestic_non_reit, precision: 2)
          else
            number_to_currency i.domestic_non_reit
          end
        end
        column "Domestic Reit", :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.domestic_reit, precision: 2)
          else
            number_to_currency i.domestic_reit
          end
        end
        column "Foreign Developed Equity", :foreign , :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.foreign_developed, precision: 2)
          else
            number_to_currency i.foreign_developed
          end
        end
        column "Foreign Emerging  Equity", :foreign , :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.foreign_emerging, precision: 2)
          else
            number_to_currency i.foreign_emerging
          end
        end
        column "Nominal Long", :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.nominal_long, precision: 2)
          else
            number_to_currency i.nominal_long
          end
        end
        column "Nominal intermediate", :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.nominal_intermediate, precision: 2)
          else
            number_to_currency i.nominal_intermediate
          end
        end
        column "Nominal short", :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.nominal_short, precision: 2)
          else
            number_to_currency i.nominal_short
          end
        end
        column "Tip Long", :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.tip_long, precision: 2)
          else
            number_to_currency i.tip_long
          end
        end
        column "Tip intermediate", :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.tip_intermediate, precision: 2)
          else
            number_to_currency i.tip_intermediate
          end
        end
        column "Tip short", :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.tip_short, precision: 2)
          else
            number_to_currency i.tip_short
          end
        end
        column "other", :other , :class => 'text-right' do |i|
          if i.display_as == :percent
            number_to_percentage(i.other, precision: 2)
          else
            number_to_currency i.other
          end
        end
      end
      render :partial => '/admin/pie_chart',
             :locals => {allocation: allocation_no_cash[1].to_h.slice(:domestic_non_reit,
                                                              :domestic_reit,
                                                              :foreign_developed,
                                                              :foreign_emerging,
                                                              :nominal_long,
                                                              :nominal_intermediate,
                                                              :nominal_short,
                                                              :tip_long,
                                                              :tip_intermediate,
                                                              :tip_short,
                                                              :cash,
                                                              :other
                                                             ).to_a, id: 'fine-no-cash-pie-chart'}

    end



    summary_info = current_admin_user.summary_info
    
    panel "Holdings" do
      allocation = summary_info.collect {|x| [x.symbol, x.value]}
      render :partial => '/admin/pie_chart',
             :locals => {allocation: allocation, id: 'holdings-pie-chart'}


    end
    panel "Holdings_no_cash" do
      allocation = summary_info.find_all {|x| !x.symbol.eql?("CASH") }.collect {|x| [x.symbol, x.value]}
      render :partial => '/admin/pie_chart',
             :locals => {allocation: allocation, id: 'holdings-pie-chart'}


    end
  end # content
end

ActiveAdmin.register Capture do
  menu priority: 80
  actions :all, :except => [:new]
  controller do
    def scoped_collection
      super.includes(:admin_user).where(admin_user_id: current_admin_user.id)
    end
    def permitted_params
      params.permit!
    end
  end

  collection_action :capture, :method => :get do
    current_admin_user.new_capture      
    redirect_to admin_captures_path
  end
  
  action_item (:index) do
    link_to('capture', capture_admin_captures_path())
  end
  
  index do
    column :time do |c|
      c.created_at
    end
    column :total, :class => 'text-right' do |c|
      number_to_currency c.total_value
    end
    column :holdings_value, :class => 'text-right' do |c|
      number_to_currency c.holdings_value
    end

    column :cash, :class => 'text-right' do |c|
      number_to_currency c.cash
    end

    column :equity, :class => 'text-right' do |c|
      number_to_currency c.equity_value
    end
    column :bonds, :class => 'text-right' do |c|
          number_to_currency c.bond_value
    end
    column :other, :class => 'text-right' do |c|
      number_to_currency c.other_value
    end                     
    actions
  end
  show do |capture|
    attributes_table do
      row :time do |c|
        c.created_at
      end
      row :cash, :class => 'text-right' do |c|
        number_to_currency c.cash
      end
      row :holdings_value, :class => 'text-right' do |c|
        number_to_currency c.holdings_value
      end 
    end
    
    
    equity = capture.equity_value
    bond = capture.bond_value
    cash = capture.cash
    total = capture.total_value
    other = capture.other_value

    domestic = capture.category_value(base_type: :equity, domestic: true)
    domestic_large = capture.category_value(base_type: :equity, reit: false, domestic: true, size: :largeCap)
    domestic_mid = capture.category_value(base_type: :equity, reit: false, domestic: true, size: :midCap)
    domestic_small = capture.category_value(base_type: :equity, reit: false, domestic: true, size: :smallCap)

    domestic_reit = capture.category_value(base_type: :equity, reit: true, domestic: true)

    foreign_reit =  capture.category_value(base_type: :equity, reit: true, domestic: false)



    foreign = capture.category_value(base_type: :equity, domestic: false)
    foreign_large = capture.category_value(base_type: :equity, reit: false, domestic: false, size: :largeCap)
    foreign_mid = capture.category_value(base_type: :equity, reit: false, domestic: false, size: :midCap)
    foreign_small = capture.category_value(base_type: :equity, reit: false, domestic: false, size: :smallCap)

    foreign_developed  = capture.category_value(base_type: :equity, domestic: false, emerging: false)
    foreing_developed_large = capture.category_value(base_type: :equity, domestic: false, emerging: false, size: :largeCap)
    foreign_developed_mid = capture.category_value(base_type: :equity, domestic: false, emerging: false, size: :midCap)
    foreign_developed_small = capture.category_value(base_type: :equity, domestic: false, emerging: false, size: :smallCap)

    foreign_emerging = capture.category_value(base_type: :equity, domestic: false, emerging: true)
    foreing_emerging_large = capture.category_value(base_type: :equity, domestic: false, emerging: true, size: :largeCap)
    foreing_emerging__mid = capture.category_value(base_type: :equity, domestic: false, emerging: true, size: :midCap)
    foreing_emerging_small = capture.category_value(base_type: :equity, domestic: false, emerging: true, size: :smallCap)

    nominal = capture.category_value(base_type: :bond, inflation_adjusted: false)
    nominal_long = capture.category_value(base_type: :bond, duration: :long, inflation_adjusted: false)
    nominal_intermediate = capture.category_value(base_type: :bond, duration: :intermediate, inflation_adjusted: false)
    nominal_short = capture.category_value(base_type: :bond, duration: :short, inflation_adjusted: false)

    tip = capture.category_value(base_type: :bond, inflation_adjusted: true)
    tip_long = capture.category_value(base_type: :bond, duration: :long, inflation_adjusted: true)
    tip_intermediate = capture.category_value(base_type: :bond, duration: :intermediate, inflation_adjusted: true)
    tip_short = capture.category_value(base_type: :bond, duration: :short, inflation_adjusted: true)


    percent_allocation =  OpenStruct.new(
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
        total: 100)
    dollar_allocation  =    OpenStruct.new(
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
      total: total )

    panel "Gross Allocation" do
      table_for [percent_allocation, dollar_allocation] do |x|
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
         column "CASH", :cash , :class => 'text-right' do |i|
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
             :locals => {allocation: [[:cash, dollar_allocation.cash], [:equity,  dollar_allocation.equity],
                                      [:bond, dollar_allocation.bond], [:other,  dollar_allocation.other]], id: 'pie-chart'}
    end
    
    
    panel "Detailed Allocation" do
      table_for [percent_allocation, dollar_allocation] do
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
             :locals => {allocation: dollar_allocation.to_h.slice(:domestic, :foreign_developed, :foreign_emerging, :nominal, :tip, :cash, :other).to_a, id: 'detailed-pie-chart'}
    end


    if capture.snapshots.count > 0
      panel "Holdings" do
        table_for capture.snapshots do
          column :account
          column :symbol do |holding|
            link_to holding.symbol, admin_ticker_path(holding.ticker)
          end
          column :shares
          column :price, :class => 'text-right' do |holding|
            number_to_currency(holding.price)
          end
          column :value, :class => 'text-right' do |holding|
            number_to_currency(holding.value)
          end
        end
      end
    end

  end
end

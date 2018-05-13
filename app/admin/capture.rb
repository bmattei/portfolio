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

    column :stocks, :class => 'text-right' do |c|
      number_to_currency c.segment_amount('stock')
    end
    column :bonds, :class => 'text-right' do |c|
      number_to_currency c.segment_amount('bond')
    end
    column :other, :class => 'text-right' do |c|
      number_to_currency c.segment_amount('other')
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
    
    total = capture.total_value()
    if total > 0
      dollar_struct =       OpenStruct.new(
        display_as: :dollar,
        stock: capture.segment_amount(:stock),
        us_stock: capture.segment_amount(:us_stock),
        non_us_stock: capture.segment_amount(:non_us_stock),
        bond: capture.segment_amount(:bond),
        other: capture.segment_amount(:other),
        holdings_cash: capture.segment_amount(:cash),
        cap_giant: capture.segment_amount(:cap_giant),
        cap_large: capture.segment_amount(:cap_large),
        cap_medium: capture.segment_amount(:cap_medium),
        cap_small: capture.segment_amount(:cap_small),
        cap_micro: capture.segment_amount(:cap_micro),
        basic_material: capture.segment_amount(:basic_material),
        consumer_cyclical: capture.segment_amount(:consumer_cyclical),
        financial_services: capture.segment_amount(:financial_services),
        realestate: capture.segment_amount(:realestate),
        communications_services: capture.segment_amount(:communications_services),
        energy: capture.segment_amount(:energy),
        industrials: capture.segment_amount(:industrials),
        technology: capture.segment_amount(:technology),
        consumer_defensive: capture.segment_amount(:consumer_defensive),
        healthcare: capture.segment_amount(:healthcare),
        utilities: capture.segment_amount(:utilities),
        americas: capture.segment_amount(:americas),
        greater_europe: capture.segment_amount(:greater_europe),
        greater_asia: capture.segment_amount(:greater_asia),
        developed: capture.segment_amount(:developed),
        emerging: capture.segment_amount(:emerging),
        government: capture.segment_amount(:government),
        corporate: capture.segment_amount(:corporate),
        securitized: capture.segment_amount(:securitized),
        municipal: capture.segment_amount(:municipal),
        bond_other: capture.segment_amount(:bond_other),
        bond_cash: capture.segment_amount(:bond_cash),
        gov_tips: capture.segment_amount(:gov_tips),
        gov_nominal: capture.segment_amount(:gov_nominal),
        cq_aaa: capture.segment_amount(:cq_aaa),
        cq_aa: capture.segment_amount(:cq_aa),
        cq_a: capture.segment_amount(:cq_a),
        cq_bbb: capture.segment_amount(:cq_bbb),
        cq_bb: capture.segment_amount(:cq_bb),
        cq_b: capture.segment_amount(:cq_b),
        cq_below_b: capture.segment_amount(:cq_below_b),
        cq_not_rated: capture.segment_amount(:cq_not_rated),
        free_cash: capture.cash,
        total: capture.total_value()
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
        dollar_struct
      ]


      panel "Gross Allocation" do
        table_for [percent_struct, dollar_struct] do |x|
          column :us_stock , :class => 'text-right' do |i|
            if i.display_as == :percent
              number_to_percentage(i.us_stock, precision: 2)
            else
              number_to_currency i.us_stock
            end
          end
          column :non_us_stock , :class => 'text-right' do |i|
            if i.display_as == :percent
              number_to_percentage(i.non_us_stock, precision: 2)
            else
              number_to_currency i.non_us_stock
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
              number_to_percentage(i.free_cash, precision: 2)
            else
              number_to_currency i.free_cash
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
               :locals => {allocation: [[:cash, dollar_struct.cash],
                                        [:us_stock,  dollar_struct.us_stock],
                                        [:non_us_stock,  dollar_struct.non_us_stock],
                                        [:bond, dollar_struct.bond],
                                        [:other,  dollar_struct.other]],
                           id: 'pie-chart'}
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
end

ActiveAdmin.register_page "Dashboard" do

  menu priority: 90, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    total = current_admin_user.total_value()
    if total > 0
      allocation = segment_allocation(total)
      portfolio = portfolio_info()
      panel "Holdings" do
        div do
          columns do
            portfolio.each do |x|
              column do
                span x[0] 
              end
            end
          end
          columns do
            portfolio.each do |x|
              column do
                number_to_percentage(x[1]/total * 100, precision: 2)
              end
            end
          end
          columns do
            portfolio.each do |x|
              column do
                number_to_currency x[1]
              end
            end
          end
        end
        render :partial => '/admin/pie_chart',
               :locals => {
                 allocation: portfolio,
                 id: 'pie-chart'
               }
        
      end
      
      
      
      panel "Asset Allocation" do
        table_for allocation do |x|
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
          column :other , :class => 'text-right' do |i|
            if i.display_as == :percent
              number_to_percentage(i.other, precision: 2)
            else
              number_to_currency i.other
            end
          end
          column :holdings_cash , :class => 'text-right' do |i|
            if i.display_as == :percent
              number_to_percentage(i.holdings_cash, precision: 2)
            else
              number_to_currency i.holdings_cash
            end
          end
          column :free_cash , :class => 'text-right' do |i|
            if i.display_as == :percent
              number_to_percentage(i.free_cash, precision: 2)
            else
              number_to_currency i.free_cash
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
        columns do
          column  name: 'With Free Cash' do
            h3 'With Free Cash'
            render :partial => '/admin/pie_chart',
                   :locals => {
                     allocation:
                       [
                         [:cash, [ allocation[1].free_cash, 0].max ],
                         [:holdings_cash, [ allocation[1].holdings_cash, 0].max ],
                         [:us_stock,  [ allocation[1].us_stock, 0 ].max],
                         [:non_us_stock,  [ allocation[1].non_us_stock, 0].max ],
                         [:bond, [ allocation[1].bond , 0 ].max ],
                         [:other,  [ allocation[1].other, 0 ].max ],
                       ],
                     id: 'pie-chart'
                   }
          end
          column  do
            h3 'Without Free Cash'
            render :partial => '/admin/pie_chart',
                   :locals => {allocation: [
                                 [:holdings_cash, [ allocation[1].holdings_cash, 0].max ],
                                 [:us_stock,  [ allocation[1].us_stock, 0 ].max ],
                                 [:non_us_stock, [  allocation[1].non_us_stock, 0 ].max ],
                                 [:bond, [ allocation[1].bond, 0 ].max ],
                                 [:other,[  allocation[1].other, 0 ].max ]
                               ],
                               id: 'pie-chart'}
          end
        end

      end
      panel 'Stock Regions' do
        table_for allocation do |x|
          column :americas , :class => 'text-right' do |i|
            if i.display_as == :percent
              number_to_percentage(i.americas, precision: 2)
            else
              number_to_currency i.americas
            end
          end
          column :greater_europe , :class => 'text-right' do |i|
            if i.display_as == :percent
              number_to_percentage(i.greater_europe, precision: 2)
            else
              number_to_currency i.greater_europe
            end
          end
          column :greater_asia , :class => 'text-right' do |i|
            if i.display_as == :percent
              number_to_percentage(i.greater_asia, precision: 2)
            else
              number_to_currency i.greater_asia
            end
          end
          column :developed , :class => 'text-right' do |i|
            if i.display_as == :percent
              number_to_percentage(i.developed, precision: 2)
            else
              number_to_currency i.developed
            end
          end
          column :emerging , :class => 'text-right' do |i|
            if i.display_as == :percent
              number_to_percentage(i.emerging, precision: 2)
            else
              number_to_currency i.emerging
            end
          end
        end
        columns do
          column do
            h3 'Regions'
            render :partial => '/admin/pie_chart',
                   :locals => {allocation: [
                                 [:americas, [ allocation[1].americas, 0].max ],
                                 [:greater_europe,  [ allocation[1].greater_europe, 0 ].max ],
                                 [:greater_asias,  [ allocation[1].greater_asia, 0].max ],
                               ],
                               id: 'pie-chart'}
          end
          column do
            h3 'Developed/Emerging'
            render :partial => '/admin/pie_chart',
                   :locals => {allocation: [
                                 [:developed, [ allocation[1].developed, 0].max ],
                                 [:emerging,  [ allocation[1].emerging, 0].max ],
                               ],
                               id: 'pie-chart'}
          end
        end
      end
      panel "Stock Sectors" do
        table_for allocation do |x|
          column :basic_material , :class => 'text-right' do |i|
            if i.display_as == :percent
              number_to_percentage(i.basic_material, precision: 2)
            else
              number_to_currency i.basic_material
            end
          end
          column :consumer_cyclical , :class => 'text-right' do |i|
            if i.display_as == :percent
              number_to_percentage(i.consumer_cyclical, precision: 2)
            else
              number_to_currency i.consumer_cyclical
            end
          end
          column :financial_services , :class => 'text-right' do |i|
            if i.display_as == :percent
              number_to_percentage(i.financial_services, precision: 2)
            else
              number_to_currency i.financial_services
            end
          end
          column :realestate , :class => 'text-right' do |i|
            if i.display_as == :percent
              number_to_percentage(i.realestate, precision: 2)
            else
              number_to_currency i.realestate
            end
          end
          column :communications_services , :class => 'text-right' do |i|
            if i.display_as == :percent
              number_to_percentage(i.communications_services, precision: 2)
            else
              number_to_currency i.communications_services
            end
          end
          column :energy , :class => 'text-right' do |i|
            if i.display_as == :percent
              number_to_percentage(i.energy, precision: 2)
            else
              number_to_currency i.energy
            end
          end
          column :industrials , :class => 'text-right' do |i|
            if i.display_as == :percent
              number_to_percentage(i.industrials, precision: 2)
            else
              number_to_currency i.industrials
            end
          end
          column :technology , :class => 'text-right' do |i|
            if i.display_as == :percent
              number_to_percentage(i.technology, precision: 2)
            else
              number_to_currency i.technology
            end
          end
          column :consumer_defensive , :class => 'text-right' do |i|
            if i.display_as == :percent
              number_to_percentage(i.consumer_defensive, precision: 2)
            else
              number_to_currency i.consumer_defensive
            end
          end
          column :healthcare , :class => 'text-right' do |i|
            if i.display_as == :percent
              number_to_percentage(i.healthcare, precision: 2)
            else
              number_to_currency i.healthcare
            end
          end
          column :utilities, :class => 'text-right' do |i|
            if i.display_as == :percent
              number_to_percentage(i.utilities, precision: 2)
            else
              number_to_currency i.utilities
            end
          end
        end # table
        columns do
          column do
            render :partial => '/admin/pie_chart',
                   :locals => {allocation: [
                                 [:basic_material, [allocation[1].basic_material, 0].max],
                                 [:consumer_cyclical, [ allocation[1].consumer_cyclical, 0].max ],
                                 [:financial_services, [ allocation[1].financial_services, 0].max ],
                                 [ :real_estate, [ allocation[1].real_estate.to_f, 0 ].max ],
                                 [:communication_services,  [allocation[1].communication_services.to_f, 0]],
                                 [:energy, [allocation[1].energy, 0].max],
                                 [:industrials,  [allocation[1].industrials, 0].max],
                                 [:technology,  [allocation[1].technology, 0].max],
                                 [:consumer_defensive, [allocation[1].consumer_defensive, 0].max],
                                 [:healthcare,  [allocation[1].healthcare, 0].max],
                                 [:utilities,  [allocation[1].utilities, 0].max],
                               ],
                               id: 'pie-chart'}

          end
          
        end # columns 
      end # panel
      if allocation[0].bond > 0
        panel 'Bond Quality' do
          table_for allocation do |x|
            column :cq_aaa , :class => 'text-right' do |i|
              if i.display_as == :percent
                number_to_percentage(i.cq_aaa, precision: 2)
              else
                number_to_currency i.cq_aaa
              end
            end
            column :cq_aa , :class => 'text-right' do |i|
              if i.display_as == :percent
                number_to_percentage(i.cq_aa, precision: 2)
              else
                number_to_currency i.cq_aa
              end
            end
            column :cq_a , :class => 'text-right' do |i|
              if i.display_as == :percent
                number_to_percentage(i.cq_a, precision: 2)
              else
                number_to_currency i.cq_a
              end
            end
            column :cq_bbb , :class => 'text-right' do |i|
              if i.display_as == :percent
                number_to_percentage(i.cq_bbb, precision: 2)
              else
                number_to_currency i.cq_bbb
              end
            end
            column :cq_bb , :class => 'text-right' do |i|
              if i.display_as == :percent
                number_to_percentage(i.cq_bb, precision: 2)
              else
                number_to_currency i.cq_bb
              end
            end
            column :cq_b , :class => 'text-right' do |i|
              if i.display_as == :percent
                number_to_percentage(i.cq_b, precision: 2)
              else
                number_to_currency i.cq_b
              end
            end
            column :cq_below_b , :class => 'text-right' do |i|
              if i.display_as == :percent
                number_to_percentage(i.cq_below_b, precision: 2)
              else
                number_to_currency i.cq_below_b
              end
            end
            column :cq_not_rated , :class => 'text-right' do |i|
              if i.display_as == :percent
                number_to_percentage(i.cq_not_rated, precision: 2)
              else
                number_to_currency i.cq_not_rated
              end
            end
          end # Table
          render :partial => '/admin/pie_chart',
                 :locals => {allocation: [
                               [:cq_aaa, [allocation[1].cq_aaa, 0].max],
                               [:cq_aa, [allocation[1].cq_aa, 0].max],
                               [:cq_a,[ allocation[1].cq_a, 0].max],
                               [:cq_bbb,  [allocation[1].cq_bbb, 0].max],
                               [:cq_bb,  [allocation[1].cq_bb, 0].max],
                               [:cq_b, [ allocation[1].cq_b, 0 ].max ],
                               [:cq_below_b,  [allocation[1].cq_below_b, 0].max],
                               [:cq_not_rated,  [allocation[1].cq_not_rated, 0].max],
                             ],
                             id: 'pie-chart'}
        end # panel bond quality

        panel 'Bond Sectors' do
          table_for allocation do |x|
            column :government , :class => 'text-right' do |i|
              if i.display_as == :percent
                number_to_percentage(i.government, precision: 2)
              else
                number_to_currency i.government
              end
            end
            column :corporate , :class => 'text-right' do |i|
              if i.display_as == :percent
                number_to_percentage(i.corporate, precision: 2)
              else
                number_to_currency i.corporate
              end
            end
            column :securitized , :class => 'text-right' do |i|
              if i.display_as == :percent
                number_to_percentage(i.securitized, precision: 2)
              else
                number_to_currency i.securitized
              end
            end
            column :municipal , :class => 'text-right' do |i|
              if i.display_as == :percent
                number_to_percentage(i.municipal, precision: 2)
              else
                number_to_currency i.municipal
              end
            end
            column :other , :class => 'text-right' do |i|
              if i.display_as == :percent
                number_to_percentage(i.bond_other, precision: 2)
              else
                number_to_currency i.bond_other
              end
            end
            column :cash_equivilent , :class => 'text-right' do |i|
              if i.display_as == :percent
                number_to_percentage(i.bond_cash, precision: 2)
              else
                number_to_currency i.bond_cash
              end
            end
            column :gov_tips , :class => 'text-right' do |i|
              if i.display_as == :percent
                number_to_percentage(i.gov_tips, precision: 2)
              else
                number_to_currency i.gov_tips
              end
            end
            column :gov_nominal , :class => 'text-right' do |i|
              if i.display_as == :percent
                number_to_percentage(i.gov_nominal, precision: 2)
              else
                number_to_currency i.gov_nominal
              end
            end
          end
          columns do
            column do
              h3 "Group all Government Bonds"
              render :partial => '/admin/pie_chart',
                     :locals => {allocation: [
                                   [:government, [allocation[1].government, 0].max],
                                   [:corporate, [allocation[1].corporate, 0].max],
                                   [:securitized, [allocation[1].securitized, 0].max],
                                   [:municipal,  [allocation[1].municipal, 0].max],
                                   [:other,  [allocation[1].bond_other, 0].max],
                                   [:cash_equivilent, [allocation[1].bond_cash, 0].max],
                                 ],
                                 id: 'pie-chart'}
            end
            column do
              h3 "Split Out Tips and Nominal Government Bonds"
              render :partial => '/admin/pie_chart',
                     :locals => {allocation: [
                                   [:gov_tips,[allocation[1].gov_tips, 0].max],
                                   [:gov_nominal,[allocation[1].gov_nominal,0].max],
                                   [:corporate, [allocation[1].corporate,0].max],
                                   [:securitized, [allocation[1].securitized, 0].max],
                                   [:municipal,  [allocation[1].municipal, 0].max],
                                   [:other,  [allocation[1].bond_other, 0].max],
                                   [:cash_equivilent, [allocation[1].bond_cash, 0].max],
                                 ],
                                 id: 'pie-chart'}
              
            end
          end
          
        end # panel Bond Sector
      end
      
    end
  end
end

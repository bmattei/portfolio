ActiveAdmin.register Ticker do
  menu priority: 60
  config.sort_order = 'symbol_asc'

  controller do
    def scoped_collection
      super.includes(:holdings, :accounts)
    end
    def permitted_params
      params.permit!
    end
  end

  filter :symbol, as: :string
  filter :category
  filter :stype, as: :select, collection: Ticker.stypes.collect {|k,v| [k,v] }

                              
  index do
    column :symbol
    column :category
    
    # column 'size or duration' do |t|
    #   if t.size
    #     t.size
    #   else
    #     t.duration
    #   end
    # end
    # column :foreign
    column :stype

    column :price , :class => 'text-right' do |t|
      number_to_currency t.last_price
    end
    
    column :total , :class => 'text-right' do |t|
      number_to_currency t.total
    end
    column :expenses do |t|
      if t.expenses
        number_to_percentage t.expenses
      end
    end
                   
    actions
  end

  show do |ticker|
    attributes_table do
      row :symbol
      row :stype
      row :category
      if ticker.expenses
        row :expenses do |t|
          number_to_percentage t.expenses 
        end
      end
      
      if ticker.aa_us_stock
        row :us_stock do |t|
          number_to_percentage t.aa_us_stock * 100
        end 
        row :non_us_stock do |t|
          number_to_percentage t.aa_non_us_stock * 100
        end
        row :bond do |t|
          number_to_percentage t.aa_bond * 100
        end
        row :cash do |t|
          number_to_percentage t.aa_cash * 100
        end
        row :other do |t|
          number_to_percentage t.aa_other * 100
        end
      end
      if ticker.quality
        row :avg_bond_quality do |t|
          t.quality
        end
        row :aaa do |t|
          number_to_percentage t.cq_aaa * 100
        end
        if ticker.cq_aa > 0
          row :aa do |t|
            number_to_percentage t.cq_aa * 100
          end
        end
        if ticker.cq_a > 0
          row :a do |t|
            number_to_percentage t.cq_a * 100
          end
        end
        if ticker.cq_bbb > 0
          row :bbb do |t|
            number_to_percentage t.cq_bbb * 100
          end
        end
        if ticker.cq_bb > 0
          row :bb do |t|
            number_to_percentage t.cq_bb * 100
          end
        end
        if ticker.cq_b > 0
          row :b do |t|
            number_to_percentage t.cq_b * 100
          end
        end
        if ticker.cq_below_b > 0
          row :below_b do |t|
            number_to_percentage t.cq_below_b * 100
          end
        end
        if ticker.cq_not_rated > 0
          row :not_rated do |t|
            number_to_percentage t.cq_not_rated * 100
          end
        end
      end
      if ticker.bs_government
        row :bond_government do |t|
          number_to_percentage t.bs_government * 100
        end
        row :bond_gov_tips do |t|
          number_to_percentage t.gov_tips * 100
        end
        row :bond_gov_nominal do |t|
          number_to_percentage t.gov_nominal * 100
        end
        row :bond_corporate do |t|
          number_to_percentage t.bs_corporate * 100
        end

        row :bond_securitized do |t|
          number_to_percentage t.bs_securitized * 100
        end
        row :bond_other do |t|
          number_to_percentage t.bs_other * 100
        end
        row :bond_cash_equivilent do |t|
          number_to_percentage t.bs_cash.to_f * 100
        end
        
      end
      if ticker.ss_basic_material
        row :basic_materials do |t|
          number_to_percentage t.ss_basic_material * 100
        end
        row :consumer_cyclical do |t|
          number_to_percentage t.ss_consumer_cyclical * 100
        end
        row :financial_services do |t|
          number_to_percentage t.ss_financial_services * 100
        end
        row :realestate do |t|
          number_to_percentage t.ss_realestate * 100
        end
        row :communications_services do |t|
          number_to_percentage t.ss_communications_services * 100
        end
        row :energy do |t|
          number_to_percentage t.ss_energy * 100
        end
        row :industrials do |t|
          number_to_percentage t.ss_industrials * 100
        end
        row :technology do |t|
          number_to_percentage t.ss_technology * 100
        end
        row :consumer_defensive do |t|
          number_to_percentage t.ss_consumer_defensive * 100
        end
        row :healthcare do |t|
          number_to_percentage t.ss_healthcare * 100
        end
        row :utilities do |t|
          number_to_percentage t.ss_utilities * 100
        end
      end
      if ticker.mr_americas
        row :americas do |t|
          number_to_percentage t.mr_americas * 100
        end 
        row :greater_europe do |t|
          number_to_percentage t.mr_greater_europe * 100
        end
        row :greater_asia do |t|
          number_to_percentage t.mr_greater_asia * 100
        end
        row :developed do |t|
          number_to_percentage t.mc_developed * 100
        end
        row :emerging do |t|
          number_to_percentage t.mc_emerging * 100
        end
      end
    end
    if ticker.prices.count > 0
      panel "prices" do
        table_for ticker.prices.order(created_at: :desc) do
          column :price
          column :price_date
        end
      end
    end
  end

end

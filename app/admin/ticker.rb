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
  filter :stype, as: :select, collection: Ticker.stypes.collect {|k,v| [k,v] }
  filter :group, as: :string
                              
  index do
    column :symbol
    
    # column 'size or duration' do |t|
    #   if t.size
    #     t.size
    #   else
    #     t.duration
    #   end
    # end
    # column :foreign
    column :stype
    column :group
    column :price , :class => 'text-right' do |t|
      (t.last_price ? number_to_currency(t.last_price) : '-')
    end

    column :price_date, :class => 'text-right' do |t|
      t.last_price_date ? t.last_price_date : '-'
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
      row :name
      row :stype
      if ticker.group
        row :group do |t|
          t.group
        end
      end
      if ticker.expenses
        row :expenses do |t|
          number_to_percentage t.expenses.to_f 
        end
      end
      
      if ticker.aa_us_stock
        row :us_stock do |t|
          number_to_percentage t.aa_us_stock.to_f * 100, precision: 1
        end 
        row :non_us_stock do |t|
          number_to_percentage t.aa_non_us_stock.to_f * 100, precision: 1
        end
        row :bond do |t|
          number_to_percentage t.aa_bond.to_f * 100, precision: 1
        end
        row :government do |t|
          number_to_percentage t.bs_government.to_f * 100, precision: 1
        end
        row :gov_nominal do |t|
          number_to_percentage t.gov_nominal.to_f * 100, precision: 1
        end
        row :gov_tips do |t|
          number_to_percentage t.gov_tips.to_f * 100, precision: 1
        end
        row :cash do |t|
          number_to_percentage t.aa_cash.to_f * 100, precision: 1
        end
        row :other do |t|
          number_to_percentage t.aa_other.to_f * 100, precision: 1
        end
      end
      if !ticker.quality.blank?
        row :avg_bond_quality do |t|
          t.quality
        end
        row "AAA" do |t|
          number_to_percentage t.cq_aaa.to_f * 100, precision: 1
        end
        row "AA" do |t|
          number_to_percentage t.cq_aa.to_f * 100, precision: 1
        end
        row "A" do |t|
          number_to_percentage t.cq_a.to_f * 100, precision: 1
        end
        
        row "BBB" do |t|
          number_to_percentage t.cq_bbb.to_f * 100, precision: 1
        end
        row "BB" do |t|
          number_to_percentage t.cq_bb.to_f * 100, precision: 1
        end
        row "B" do |t|
          number_to_percentage t.cq_b.to_f * 100, precision: 1
        end
        row "Below B" do |t|
          number_to_percentage t.cq_below_b.to_f * 100, precision: 1
        end
        row "Not Rated" do |t|
          number_to_percentage t.cq_not_rated.to_f * 100, precision: 1
        end
      end
      if ticker.bs_government.to_f > 0
        row :bond_government do |t|
          number_to_percentage t.bs_government.to_f * 100, precision: 1 
        end
        row :bond_gov_tips do |t|
          number_to_percentage t.gov_tips.to_f * 100, precision: 1
        end
        row :bond_gov_nominal do |t|
          number_to_percentage t.gov_nominal.to_f * 100, precision: 1
        end
        row :bond_corporate do |t|
          number_to_percentage t.bs_corporate.to_f * 100, precision: 1
        end

        row :bond_securitized do |t|
          number_to_percentage t.bs_securitized.to_f * 100, precision: 1
        end
        row :bond_other do |t|
          number_to_percentage t.bs_other.to_f * 100, precision: 1
        end
        row :bond_cash_equivilent do |t|
          number_to_percentage t.bs_cash.to_f * 100, precision: 1
        end
        
      end
      if ticker.ss_basic_material
        row :basic_materials do |t|
          number_to_percentage t.ss_basic_material.to_f * 100, precision: 1
        end
        row :consumer_cyclical do |t|
          number_to_percentage t.ss_consumer_cyclical.to_f * 100, precision: 1
        end
        row :financial_services do |t|
          number_to_percentage t.ss_financial_services.to_f * 100, precision: 1
        end
        row :realestate do |t|
          number_to_percentage t.ss_realestate.to_f * 100, precision: 1
        end
        row :communications_services do |t|
          number_to_percentage t.ss_communications_services.to_f * 100, precision: 1
        end
        row :energy do |t|
          number_to_percentage t.ss_energy.to_f * 100, precision: 1
        end
        row :industrials do |t|
          number_to_percentage t.ss_industrials.to_f * 100, precision: 1
        end
        row :technology do |t|
          number_to_percentage t.ss_technology.to_f * 100, precision: 1
        end
        row :consumer_defensive do |t|
          number_to_percentage t.ss_consumer_defensive.to_f * 100, precision: 1
        end
        row :healthcare do |t|
          number_to_percentage t.ss_healthcare.to_f * 100, precision: 1
        end
        row :utilities do |t|
          number_to_percentage t.ss_utilities.to_f * 100, precision: 1
        end
      end
      if ticker.mr_americas
        row :americas do |t|
          number_to_percentage t.mr_americas.to_f * 100, precision: 1
        end 
        row :greater_europe do |t|
          number_to_percentage t.mr_greater_europe.to_f * 100, precision: 1
        end
        row :greater_asia do |t|
          number_to_percentage t.mr_greater_asia.to_f * 100, precision: 1
        end
        row :developed do |t|
          number_to_percentage t.mc_developed.to_f * 100, precision: 1
        end
        row :emerging do |t|
          number_to_percentage t.mc_emerging.to_f * 100, precision: 1
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

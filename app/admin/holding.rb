ActiveAdmin.register Holding do
  menu priority: 50
  config.per_page = 50


  
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end



  controller do
    active_admin_config.sort_order = ''

    def scoped_collection
      super.includes(:ticker, :account).where(accounts: {admin_user_id: current_admin_user.id}).reorder('tickers.symbol asc', shares: :desc)
    end
    def permitted_params
      params.permit!
    end

    
  end

  batch_action :retrieve_fund_data, :if => proc { true } do |ids|
    begin
      unique_ids = ids.uniq
      unique_ids.each do |id|
        holding = Holding.find(id)
        holding.retrieve_fund_info
      end
      flash[:notice] = "Data Updated"
      redirect_back fallback_location: admin_holdings_path
    rescue StandardError => e
      flash[:notice] = e.message
      redirect_back fallback_location: admin_holdings_path
    end
    
    
  end

  form do |f| 
    f.inputs do
      if current_admin_user.admin 
        input :account
      else
        input :account, as: :select, collection: current_admin_user.accounts
      end
      input :ticker, as: :select, collection: Ticker.all.order(:symbol).collect {|x| [x.symbol, x.id]}
      input :shares
      input :purchase_price

      input :purchase_date, as: :datepicker
    end
    f.actions
  end

  #  filter :ticker_symbol, as: :select, collection: proc {Ticker.all.collect {|x| x.symbol}}
  filter :ticker_symbol, as: :string
  filter :account_name, as: :string
  filter :account_brokerage, as: :string, label: 'Brokerage'
  filter :shares

  index do

    selectable_column
    column :account, sortable: "accounts.name"
    column :brokerage, sortable: "accounts.brokerage" do |holdings|
      holdings.account.brokerage
    end
    column :symbol,  sortable: "tickers.symbol" do |holding|
      link_to holding.symbol, admin_ticker_path(holding.ticker)
    end
    column :shares, sortable: "shares" do |holding|
      best_in_place holding, :shares, as: :input, url: admin_holding_path(holding)
    end
    column :purchase_price do |holding|
      number_to_currency(holding.purchase_price)
    end
    column :price do |holding|
      number_to_currency(holding.price)
    end
    column :value do |holding|
      number_to_currency(holding.value)
    end
    actions
    summary_info = current_admin_user.summary_info
    table_for summary_info.sort {|x,y| y.value <=> x.value}, id: 'summary-tbl'  do
      column :symbol
      column :shares, class: 'text-right' do |holding|
        if holding.symbol != "CASH" 
          "%.1f" % holding.shares.to_f
        end
      end
      column :price , class: 'text-right' do |holding|
        number_to_currency holding.price
      end
      column :value, class: 'text-right' do |holding|
        number_to_currency holding.value
      end
      column :description
      column :expenses, class: 'text-right' do |holding|
        number_to_percentage(holding.expenses, precision: 2)
      end
      column :us_equity, class: 'text-right' do |holding|
        number_to_percentage(holding.us_equity.to_f * 100, precision: 0)
      end
      column :foreign_equity, class: 'text-right' do |holding|
        number_to_percentage(holding.foreign_equity.to_f * 100 , precision: 0)
      end
      column :bond, class: 'text-right' do |holding|
        number_to_percentage(holding.bond.to_f * 100, precision: 0)
      end
      column :cash, class: 'text-right' do |holding|
        number_to_percentage(holding.cash.to_f * 100, precision: 0)
      end
      column :other, class: 'text-right' do |holding|
        number_to_percentage(holding.other.to_f * 100, precision: 0)
      end
      
      column "% of Portfolio", class: 'text-right' do |holding|
        number_to_percentage(holding.percent * 100, precision: 2)
      end
    end
  end

  show do |holdings|
    attributes_table do
      row :account
      row :name
      row :symbol do |holding|
        link_to holding.symbol, admin_ticker_path(holding.ticker)
      end
      row :shares do |holding|
        '%.2f' % holding.shares
      end
      row :purchase_price do |holding|
        number_to_currency(holding.purchase_price)
      end
      row :price do |holding|
        number_to_currency(holding.price)
      end
      row :value do |holding|
        number_to_currency(holding.value)
      end
      if holding.group
        row :group do |holding|
          holding.group
        end
      end
      if holding.expenses
        row :expenses do |holding|
          number_to_percentage holding.expenses.to_f 
        end
      end
      if holding.aa_us_stock
        row :us_stock do |h|
          number_to_percentage h.aa_us_stock.to_f * 100, precision: 1
        end 
        row :non_us_stock do |h|
          number_to_percentage h.aa_non_us_stock.to_f * 100, precision: 1
        end
        row :bond do |h|
          number_to_percentage h.aa_bond.to_f * 100, precision: 1
        end
        row :government do |h|
          number_to_percentage h.bs_government.to_f * 100, precision: 1
        end
        row :gov_nominal do |h|
          number_to_percentage h.gov_nominal.to_f * 100, precision: 1
        end
        row :gov_tips do |h|
          number_to_percentage h.gov_tips.to_f * 100, precision: 1
        end
        row :cash do |h|
          number_to_percentage h.aa_cash.to_f * 100, precision: 1
        end
        row :other do |h|
          number_to_percentage h.aa_other.to_f * 100, precision: 1
        end
      end
      if !holding.quality.blank?
        row :avg_bond_quality do |h|
          t.quality
        end
        row "AAA" do |h|
          number_to_percentage h.cq_aaa.to_f * 100, precision: 1
        end
        row "AA" do |h|
          number_to_percentage t.cq_aa.to_f * 100, precision: 1
        end
        row "A" do |h|
          number_to_percentage h.cq_a.to_f * 100, precision: 1
        end
        
        row "BBB" do |h|
          number_to_percentage h.cq_bbb.to_f * 100, precision: 1
        end
        row "BB" do |h|
          number_to_percentage h.cq_bb.to_f * 100, precision: 1
        end
        row "B" do |h|
          number_to_percentage h.cq_b.to_f * 100, precision: 1
        end
        row "Below B" do |h|
          number_to_percentage h.cq_below_b.to_f * 100, precision: 1
        end
        row "Not Rated" do |h|
          number_to_percentage h.cq_not_rated.to_f * 100, precision: 1
        end
      end
      if holding.bs_government.to_f > 0
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
      if holding.ss_basic_material
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
      if holding.mr_americas
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

  if holding.prices.count > 0
    panel "Prices" do
      table_for holdings.prices.order(price_date: :desc)  do
        column :price do |p|
          number_to_currency(p.price)
        end
        column :price_date
      end
    end
    
  end
end
end

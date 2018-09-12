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

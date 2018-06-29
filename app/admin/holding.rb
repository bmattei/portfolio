ActiveAdmin.register Holding do
    menu priority: 50

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
    def scoped_collection
        super.includes(:ticker, :account).where(accounts: {admin_user_id: current_admin_user.id})
    end
    def permitted_params
      params.permit!
    end

   
  end

  collection_action :snap_shot, :method => :get do
    Snapshot.capture      
    redirect_to admin_holdings_path
  end
  
  action_item (:index) do
    link_to('snap_shot', snap_shot_admin_holdings_path())
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

  filter :ticker_symbol, as: :select, collection: proc {Ticker.all.collect {|x| x.symbol}}
  filter :account
  filter :shares

  index do

    summary_info = current_admin_user.summary_info
    table_for summary_info.sort {|x,y| y.value <=> x.value} do
      column :symbol
      column :shares
      column :price , class: 'text-right' do |ticker|
        number_to_currency ticker.price
      end
      column :value, class: 'text-right' do |ticker|
        number_to_currency ticker.value
      end
      column :description
      column :expenses, class: 'text-right' do |ticker|
        number_to_percentage(ticker.expenses, precision: 2)
      end
      column :equity, class: 'text-right' do |ticker|
        number_to_percentage(ticker.equity.to_f * 100, precision: 0)
      end
      column :foreign_equity, class: 'text-right' do |ticker|
        number_to_percentage(ticker.foreign_equity.to_f * 100 , precision: 0)
      end
      column :bond, class: 'text-right' do |ticker|
        number_to_percentage(ticker.bond.to_f * 100, precision: 0)
      end
      column :percent, class: 'text-right' do |ticker|
        number_to_percentage(ticker.percent, precision: 2)
      end
    end
    
    selectable_column
    column :account, sortable: "accounts.name"
    column :brokerage, sortable: "accounts.brokerage" do |holdings|
      holdings.account.brokerage
    end
    column :name
    column :symbol,  sortable: "tickers.symbol" do |holding|
      link_to holding.symbol, admin_ticker_path(holding.ticker)
    end
    column :shares, sortable: "shares" do |holding|
      best_in_place holding, :shares, as: :input, url: admin_holding_path(holding)
    end
    column :purchase_price
    column :price
    column :value do |holding|
      number_to_currency(holding.value)
    end
    actions
  end

  show do |holdings|
    attributes_table do
      row :account
      row :name
      row :symbol do |holding|
        link_to holding.symbol, admin_ticker_path(holding.ticker)
      end
      row :shares
      row :purchase_price
      row :price
      row :value do |holding|
        number_to_currency(holding.value)
      end
    end
    if holding.prices.count > 0
      panel "Prices" do
        table_for holdings.prices do
          column :ticker,  sortable: "tickers.symbol" do |p|
            p.symbol if p.ticker
          end
          column :name do |p|
            p.name if p.ticker
          end
          column :price
          column :price_date
        end
      end

    end
  end
end

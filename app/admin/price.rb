ActiveAdmin.register Price do
      menu priority: 70


  config.sort_order = "price_date_desc"

  controller do
    def scoped_collection
      super.includes(:ticker)
    end
    def permitted_params
      params.permit!
    end
  end
  form do |f| 
    f.inputs do
      input :ticker, collection: Ticker.all.order(:symbol).collect {|x| [x.symbol, x.id]}
      input :price 
      input :price_date, as: :datepicker
    end
    f.actions
  end



  #  ACTIONS
  
  collection_action :update_quotes, :method => :get do
    Ticker.retrieve_all_prices
    Account.all.each do |account|
      account.update_values
    end
    redirect_to admin_prices_path
  end

  action_item (:index) do
    link_to('update_quotes', update_quotes_admin_prices_path())
  end


  filter :ticker_symbol, as: :string
  filter :price
  filter :price_date
  index do
    column :ticker,  sortable: "tickers.symbol" do |p|
      p.symbol if p.ticker
    end
    column :price, :class => 'text-right' do |p|
      number_to_currency p.price
    end
    column :price_date
    actions
  end
end

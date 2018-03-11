ActiveAdmin.register Price do
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

  config.sort_order = "updated_price_date"

  controller do
    def scoped_collection
      super.includes(:ticker).order("tickers.symbol asc, prices.price_date desc")
    end
    def permitted_params
      params.permit!
    end
  end
  form do |f| 
    f.inputs do
      input :ticker, as: :select, collection: Ticker.all.collect {|x| [x.symbol, x.id]}
      input :price
      input :price_date, as: :datepicker
    end
    f.actions
  end



  #  ACTIONS
  
  collection_action :update_quotes, :method => :get do
    Ticker.retrieve_prices
#    price_importer = ImportAllPrices.new()
#    price_importer.import_all
    Account.all.each do |account|
      account.update_values
    end
    redirect_to admin_prices_path
  end

  action_item (:index) do
    link_to('update_quotes', update_quotes_admin_prices_path())
  end


  filter :ticker_name, as: :string
  filter :ticker_symbol, as: :string
  filter :price
  filter :price_date
  index do
    selectable_column
    column :ticker,  sortable: "tickers.symbol" do |p|
      p.symbol if p.ticker
    end
    column :name do |p|
      p.name if p.ticker
    end
    column :price
    column :price_date
    actions
  end
end

ActiveAdmin.register Account do
  scope_to :current_admin_user, unless: proc { current_admin_user.admin? }
  config.sort_order = 'total_value_desc'
  
  controller do
    def scoped_collection
      super.includes(:admin_user, :account_type).where(admin_user_id: current_admin_user.id).
        order(total_value: :desc)
    end
    def permitted_params
      byebug
      params.permit!
    end
  end

  filter :admin_user_email, as: :select, label: :owner, collection: proc { AdminUser.all.collect {|x| x.email } }
  filter :name, label: "Account Name"
  filter :brokerage
  filter :cash
  filter :total_value,  filters: [:equals, :greater_than, :less_than]
  
  index do
    selectable_column
    column  :owner, sortable: "admin_users.email" do |a|
      a.admin_user.email
    end
    column  :name, sortable: "name" do |account|
      best_in_place account, :name, as: :input, url: admin_account_path(account)
    end
    column  :brokerage, sortable: "brokerage" do |account|
      best_in_place account, :brokerage, as: :input, url: admin_account_path(account)
    end
    column :tax_status, sortable: "account_types.name" do |a|
      best_in_place a, :account_type_id, as: :select, collection: AccountType.all.map {|i| [i.id, i.name] },  url: admin_account_path(a)
    end
    column  "holdings Value", sortable: :holdings_value, class: 'text-right' do |a|
      number_to_currency(a.holdings_value)
    end
    column  :cash, sortable: 'free_cash', class: 'text-right' do |account|
      best_in_place account, :cash, as: :input, url: admin_account_path(account), display_with: :number_to_currency
    end
    column :holdings_cash, :class => 'text-right' do |a|
      number_to_currency a.segment_amount(:cash)
    end
    column :stock, :class => 'text-right' do |a|
      number_to_currency a.segment_amount(:stock)
    end
    column :bond, :class => 'text-right' do |a|
      number_to_currency a.segment_amount(:bond)
    end
    column :other,  :class => 'text-right' do |a|
      number_to_currency a.segment_amount(:other)
    end
    column  "Total Value", sortable: :total_value, class: 'text-right' do |a|
      number_to_currency(a.total_value)
    end
    actions

    brokerages = Account.all.collect { |x| x.brokerage}.uniq

    
    
    
  
    # Accounts totalled by tax type
    
    account_type_info = [

      OpenStruct.new(summary: "TaxFree Accounts",
                     holdings_value: collection.where(account_type_id: AccountType::TaxFree).limit(nil).inject(0) { |sum, n| sum + n.holdings_value.to_f },
                     cash: collection.where(account_type_id: AccountType::TaxFree).sum(:cash),
                     total_value: collection.where(account_type_id: AccountType::TaxFree).limit(nil).inject(0) { |sum,n| sum + n.total_value.to_f }),
      OpenStruct.new(summary: "TaxFree Deferred",
                     holdings_value: collection.where(account_type_id: AccountType::TaxDeferred).limit(nil).inject(0) { |sum, n| sum + n.holdings_value.to_f },
                     cash: collection.where(account_type_id: AccountType::TaxDeferred).sum(:cash),
                     total_value: collection.where(account_type_id: AccountType::TaxDeferred).limit(nil).inject(0) { |sum,n| sum + n.total_value.to_f }),
      OpenStruct.new(summary: "Taxable",
                     holdings_value: collection.where(account_type_id: AccountType::Taxable).limit(nil).inject(0) { |sum, n| sum + n.holdings_value.to_f },
                     cash: collection.where(account_type_id: AccountType::Taxable).sum(:cash),
                     total_value: collection.where(account_type_id: AccountType::Taxable).limit(nil).inject(0) { |sum,n| sum + n.total_value.to_f }),
      OpenStruct.new(summary: "All Accounts",
                     holdings_value: collection.limit(nil).inject(0) { |sum, n| sum + n.holdings_value.to_f },
                     cash: collection.sum(:cash),
                     total_value: collection.limit(nil).inject(0) { |sum,n| sum + n.total_value.to_f }),
      
      
    ]

    table_for account_type_info do
      column :summary
      column :holding_value, :class => 'text-right' do |i|
        number_to_currency i.holdings_value
      end
      column :cash, :class => 'text-right' do |i|
        number_to_currency i.cash
      end
      column :total_value, :class => 'text-right' do |i|
        number_to_currency i.total_value
      end
    end

    # Accounts totalled by brokerage
    brokerage_info = brokerages.collect do  |b|
      OpenStruct.new(summary: b,
                     holdings_value: collection.where(brokerage: b).limit(nil).inject(0) { |sum, n| sum + n.holdings_value.to_f },
                     cash: collection.where(brokerage: b).limit(nil).sum(:cash),
                     total_value: collection.where(brokerage: b).limit(nil).inject(0) { |sum,n| sum + n.total_value.to_f })
    end

    table_for brokerage_info do
      column :summary
      column :holding_value, :class => 'text-right' do |i|
        number_to_currency i.holdings_value
      end
      column :cash, :class => 'text-right' do |i|
        number_to_currency i.cash
      end
      column :total_value, :class => 'text-right' do |i|
        number_to_currency i.total_value
      end
    end



  end
  show do |account|
    attributes_table do
      row :name
      row :brokerage
      row "holdings Value", :class => 'text-right' do |a|
        number_to_currency(a.holdings_value)
      end
      row  "Cash", :class => 'text-right' do |a|
        number_to_currency(a.cash)
      end
      row  "Total Value", :class => 'text-right' do |a|
        number_to_currency(a.total_value)
      end
    end
    if account.holdings.count > 0
      panel "Holdings" do
        table_for account.holdings do
          column :name
          column :symbol do |holding|
            link_to holding.symbol, admin_ticker_path(holding.ticker)
          end
          column :shares
          column :purchase_price, :class => 'text-right' do |holding|
            number_to_currency(holding.purchase_price)
          end
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
  form do |f|
    f.inputs do
      f.input :admin_user, as: :select, collection: AdminUser.all.map {|u| [u.email, u.id] }
      f.input :name
      f.input :account_number
      f.input :brokerage
      f.input :cash
      f.has_many :holdings do |holding|
        holding.input :ticker, as: :select, collection: Ticker.all.order(:symbol).map {|t| [t.symbol, t.id] }
        holding.input :shares
        holding.input :purchase_price
      end
    end
    actions
  end

  collection_action :update_etrade, method: :get do
    consumer = OAuth::Consumer.new(CONSUMER_TOKEN[:token],CONSUMER_TOKEN[:secret],{:site => "https://etws.etrade.com", :http_method => :get})
    request_token = consumer.get_request_token()
    @url = "https://us.etrade.com/e/t/etws/authorize?key=#{OAuth::Helper.escape(CONSUMER_TOKEN[:token])}&token=#{OAuth::Helper.escape(request_token.token)}"

    
  end
  collection_action :do_update_etrade, method: :post do
    pin  =   params[:notification][:token]
    access_token = consumer.get_access_token(request_token,{:oauth_verifier => pin})

  end
  action_item (:index) do
    link_to('update_etrade', update_etrade_admin_accounts_path())
  end

end

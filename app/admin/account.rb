ActiveAdmin.register Account do
  scope_to :current_admin_user, unless: proc { current_admin_user.admin? }
  config.sort_order = 'total_value_desc'
  
  controller do
    def scoped_collection
      super.includes(:admin_user, :account_type).order(total_value: :desc)
    end
    def permitted_params
      params.permit!
    end
  end

  filter :name, label: "Account Name"
  filter :brokerage
  filter :cash
  filter :total_value,  filters: [:equals, :greater_than, :less_than]
  
  index do
    selectable_column
    if current_admin_user.admin?
      column  :owner, sortable: "admin_users.email" do |a|
        a.admin_user.email
      end
    end
    column  :name, sortable: "name" do |account|
      best_in_place account, :name, as: :input, url: admin_account_path(account)
    end
    column :account_number
    column  :brokerage, sortable: "brokerage" do |account|
      best_in_place account, :brokerage, as: :input, url: admin_account_path(account)
    end
    column :tax_status, sortable: "account_types.name" do |a|
      best_in_place a, :account_type_id, as: :select, collection: AccountType.all.map {|i| [i.id, i.name] },  url: admin_account_path(a)
    end
    column  "holdings Value", sortable: :holdings_value, class: 'text-right' do |a|
      number_to_currency(a.holdings_value)
    end
    column  :free_cash, sortable: 'cash', class: 'text-right' do |account|
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

    brokerages = collection.collect { |x| x.brokerage}.uniq

    
    
    
    
    # Accounts totalled by tax type
    
    account_type_info = [

      OpenStruct.new(account_type: "TaxFree",
                     holdings_value: collection.where(account_type_id: AccountType::TaxFree).limit(nil).inject(0) { |sum, n| sum + n.holdings_value.to_f },
                     cash: collection.where(account_type_id: AccountType::TaxFree).sum(:cash),
                     total_value: collection.where(account_type_id: AccountType::TaxFree).limit(nil).inject(0) { |sum,n| sum + n.total_value.to_f }),
      OpenStruct.new(account_type: "Tax Deferred",
                     holdings_value: collection.where(account_type_id: AccountType::TaxDeferred).limit(nil).inject(0) { |sum, n| sum + n.holdings_value.to_f },
                     cash: collection.where(account_type_id: AccountType::TaxDeferred).sum(:cash),
                     total_value: collection.where(account_type_id: AccountType::TaxDeferred).limit(nil).inject(0) { |sum,n| sum + n.total_value.to_f }),
      OpenStruct.new(account_type: "Taxable",
                     holdings_value: collection.where(account_type_id: AccountType::Taxable).limit(nil).inject(0) { |sum, n| sum + n.holdings_value.to_f },
                     cash: collection.where(account_type_id: AccountType::Taxable).sum(:cash),
                     total_value: collection.where(account_type_id: AccountType::Taxable).limit(nil).inject(0) { |sum,n| sum + n.total_value.to_f }),
      OpenStruct.new(account_type: "All Accounts",
                     holdings_value: collection.limit(nil).inject(0) { |sum, n| sum + n.holdings_value.to_f },
                     cash: collection.sum(:cash),
                     total_value: collection.limit(nil).inject(0) { |sum,n| sum + n.total_value.to_f }),
      
      
    ]

    table_for account_type_info do
      column :account_type
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
      OpenStruct.new(brokerage: b,
                     holdings_value: collection.where(brokerage: b).limit(nil).inject(0) { |sum, n| sum + n.holdings_value.to_f },
                     cash: collection.where(brokerage: b).limit(nil).sum(:cash),
                     total_value: collection.where(brokerage: b).limit(nil).inject(0) { |sum,n| sum + n.total_value.to_f })
    end

    table_for brokerage_info.sort { |a, b| b.total_value <=> a.total_value } do
      column :brokerage
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
      row :account_type
      row "holdings Value" do |a|
        number_to_currency(a.holdings_value)
      end
      row  "Cash"  do |a|
        number_to_currency(a.cash)
      end
      row  "Total Value" do |a|
        number_to_currency(a.total_value)
      end
    end
    if account.holdings.count > 0
      panel "Holdings" do
        table_for account.holdings.joins(:ticker).order("tickers.symbol asc")  do
          column :symbol do |holding|
            link_to holding.symbol, admin_ticker_path(holding.ticker)
          end
          column :shares, :class => 'text-right' do |holding| 
            "%.2f" % holding.shares
          end
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
      if account.total_value > 0
                  total = account.total_value.to_f
          dollar_struct = OpenStruct.new(
            display_as: :dollar,
            us_stock: account.segment_amount(:us_stock).to_f,
            non_us_stock: account.segment_amount(:non_us_stock).to_f,
            bond: account.segment_amount(:bond).to_f,
            free_cash: account.cash.to_f,
            holdings_cash: account.segment_amount(:cash).to_f,
            other: account.segment_amount(:other).to_f,
            total: total.to_f
          )
          percent_struct = OpenStruct.new(
            display_as: :percent,
            us_stock: (dollar_struct.us_stock.to_f/total).to_f * 100,
            non_us_stock: (dollar_struct.non_us_stock.to_f/total).to_f * 100,
            bond: (dollar_struct.bond.to_f/total).to_f * 100,
            free_cash: (dollar_struct.cash.to_f/total).to_f * 100,
            holdings_cash: (dollar_struct.holdings_cash.to_f/total).to_f * 100,
            other: (dollar_struct.other.to_f/total).to_f * 100,
            total: 100
          )
          
          allocation = [
            dollar_struct,
            percent_struct
          ]
          
          

          panel "Allocation" do
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
          end
          columns do
            column do
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
          end
      end
    end
    
  end
  form do |f|
    f.inputs do
      f.semantic_errors *f.object.errors.keys

      f.input :admin_user, as: :select, collection: AdminUser.all.map {|u| [u.email, u.id] }
      f.input :name
      f.input :account_number
      f.input :brokerage
      f.input :account_type
      f.input :cash
      f.has_many :holdings do |holding|
        holding.input :ticker, as: :select, collection: Ticker.all.order(:symbol).map {|t| [t.symbol, t.id] }
        holding.input :shares
        holding.input :purchase_price
      end
    end
    actions
  end


end

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
  
  index do
    column :symbol
    column :base_type
    column :description
    
    # column 'size or duration' do |t|
    #   if t.size
    #     t.size
    #   else
    #     t.duration
    #   end
    # end
    # column :foreign
    column :price , :class => 'text-right' do |t|
      number_to_currency t.last_price
    end
    column :shares, :class => 'text-right' do |t|
      t.shares.round(2)
    end
    column :total , :class => 'text-right' do |t|
      number_to_currency t.total
    end
    actions
  end

  show do |ticker|
    attributes_table do
      row :name
      row :symbol
      if ticker.prices.count > 0
        panel "prices" do
          table_for ticker.prices do
            column :price
            column :price_date
          end
        end
      end
    end
  end
end

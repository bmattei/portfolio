ActiveAdmin.register Ticker do
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

  config.sort_order = 'symbol_asc'
  
  controller do
    def permitted_params
      params.permit!
    end
  end

  index do
    column :symbol
    column :base_type
    column 'size or duration' do |t|
      if t.size
        t.size
      else
        t.duration
      end
    end
    column :foreign
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

ActiveAdmin.register SsFactor do
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
      def permitted_params
        params.permit!
      end
    end
    index do
      selectable_column
      column :year
      column :max_earnings
      column :factor
      column :ss_tax_rate, :class => 'text-right' do |i|
        number_to_percentage(i.ss_tax_rate * 100, precision: 3) if i.ss_tax_rate
      end
      column :medicare_tax_rate, :class => 'text-right' do |i|
        number_to_percentage((i.medicare_tax_rate * 100), precision: 3) if i.medicare_tax_rate
      end
      actions
    end
      
    
end


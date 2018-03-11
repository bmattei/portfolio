ActiveAdmin.register Earning do
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
    column :user
    column :year
    column :ss_earnings do |x|
      number_to_currency(x.amount)
    end
    column :ss_tax do |x|
      number_to_currency(x.ss_tax)
    end
    column :ss_tax_current do |x|
      number_to_currency(x.ss_tax_current)
    end
  end
end

ActiveAdmin.register User, as: "SS_USER" do
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

  menu label: 'SS_USER'
  controller do
    def permitted_params
      params.permit!
    end
  end
  index do
    column :first_name
    column :last_name
    column :date_of_birth
    column :full_ss_age
    column :ss_contribution do |x|
      number_to_currency(x.ss_contribution)
    end
    column :ss_at_62 do |x|
      number_to_currency(x.ss_at_62)
    end
    column :ss_at_full_retirement do |x|
      number_to_currency(x.ss_at_full_retirement)
    end
    column :ss_at_70 do |x|
      number_to_currency(x.ss_at_70)
    end
    
    actions

  end
end

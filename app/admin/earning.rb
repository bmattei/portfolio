ActiveAdmin.register Earning do
  controller do
    def scoped_collection
        super.includes(:user).where(users: {admin_user_id: current_admin_user.id})
    end
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
#    column :ss_tax do |x|
#      number_to_currency(x.ss_tax)
#    end
#    column :ss_tax_current do |x|
#      number_to_currency(x.ss_tax_current)
#    end
    actions
  end
  form do |f|
    f.inputs do
      f.semantic_errors *f.object.errors.keys
      f.input :year
      f.input :amount
    end
    actions
  end
end


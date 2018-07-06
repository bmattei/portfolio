ActiveAdmin.register AdminUser,  as: "User"  do
  config.filters = false

  menu priority: 100, label: "Users"
  permit_params :email, :password, :password_confirmation, :admin





  controller do
    def update
      if params[:admin_user][:password].blank?
        params[:admin_user].delete("password")
        params[:admin_user].delete("password_confirmation")
      end
      super
    end
  end
  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  form do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
      if (current_admin_user.admin)
        f.input :admin, label: :admin
      end
    end
    f.actions
  end

end

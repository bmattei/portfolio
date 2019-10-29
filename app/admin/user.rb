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

  controller do
    def permitted_params
      params.permit!
    end
  end
  menu label: 'SS_USER', priority: 120
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

  show do |users|
    attributes_table do
      row :first_name
      row :last_name
      row :date_of_birth
      row :full_ss_age
      row :ss_contribution do |x|
        number_to_currency(x.ss_contribution)
      end
      row :ss_at_62 do |x|
        number_to_currency(x.ss_at_62)
      end
      row :ss_at_full_retirement do |x|
        number_to_currency(x.ss_at_full_retirement)
      end
      row :ss_at_70 do |x|
        number_to_currency(x.ss_at_70)
      end
    end
    render "ss_form"
    render "ss_earnings_form"
  end

  member_action :import_ss_earning_data, method: :post do
    user = User.find(params[:id])
    file_path = params[:path]
    if File.file?(file_path) && File.extname(file_path) == ".pdf"
      result = user.import_earnings(file_path)
      if result
        flash[:notice] = "Data Imported"
      else
        flash[:notice] = "Problem Importing Earnings"
      end
    else
      flash[:notice] = "PDF not found #{params[:path]}"
    end
    redirect_back(fallback_location: root_path)

  end

  member_action :calculate_ss, method: :post do
    user = User.find(params[:id])
    ss_amount = user.ss_at_age(params[:age_in_years].to_i, params[:age_in_months].to_i)
    if ss_amount
      flash[:notice] = "SS ate age #{params[:age_in_years]} years , months #{params[:age_in_months]} is  $#{ss_amount.round(2)}"
    else
      flash[:notice] = "There is no earning data for this user.  SS Amount cannot be calculated"
    end
    redirect_back(fallback_location: root_path)
  end

end

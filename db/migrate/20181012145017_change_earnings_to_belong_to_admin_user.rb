class ChangeEarningsToBelongToAdminUser < ActiveRecord::Migration[5.2]
  def change
    rename_column :earnings, :user_id, :admin_user_id
  end
end

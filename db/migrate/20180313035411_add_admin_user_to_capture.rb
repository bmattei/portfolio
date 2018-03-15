class AddAdminUserToCapture < ActiveRecord::Migration[5.0]
  def change
    add_column :captures, :admin_user_id, :integer
  end
end

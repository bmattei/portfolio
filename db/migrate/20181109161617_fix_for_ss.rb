class FixForSs < ActiveRecord::Migration[5.2]
  def change
    rename_column :earnings, :admin_user_id, :user_id
  end
  
end

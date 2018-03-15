class ModifyAdmin < ActiveRecord::Migration[5.0]
  def change
    add_column :admin_users, :admin, :boolean
  end
end

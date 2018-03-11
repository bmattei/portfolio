class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string   :name
      t.string   :account_number
      t.string   :brokerage
      t.integer  :account_type_id
      t.integer  :admin_user_id
      t.decimal  :cash, precision: 16, scale: 2
      t.decimal  :holdings_value, precision: 16, scale: 2
      t.decimal  :total_value, precision: 16, scale: 2
      t.timestamps null: false
    end
  end
end

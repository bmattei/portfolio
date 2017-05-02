class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string   :name
      t.string   :account_number
      t.string   :brokerage
      t.integer  :account_type_id
      t.integer  :owner_id
      t.timestamps null: false
    end
  end
end

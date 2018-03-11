class CreatePortfolios < ActiveRecord::Migration
  def change
    create_table :portfolios do |t|
      t.string   :name
      t.string   :account
      t.string   :brokerage
      t.integer  :account_type_id
      t.integer  :owner_id
      t.timestamps null: false
    end
  end
end

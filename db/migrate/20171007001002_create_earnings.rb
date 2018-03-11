class CreateEarnings < ActiveRecord::Migration[5.0]
  def change
    create_table :earnings do |t|
      t.integer :year
      t.integer :user_id
      t.decimal :amount          
      t.timestamps
    end
  end
end

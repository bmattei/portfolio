class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.date   :date_of_birth
      t.timestamps
    end
    add_index :users, [:first_name, :last_name, :date_of_birth], unique: true
  end
end

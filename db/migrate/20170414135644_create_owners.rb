class CreateOwners < ActiveRecord::Migration
  def change
    create_table :owners do |t|
      t.string    :name
      t.string    :owner_id
      t.timestamps null: false
    end
  end
end

class CreateGroupings < ActiveRecord::Migration[5.1]
  def change
    create_table :groupings do |t|
      t.integer :super_group
      t.integer :group
      t.string :description
      t.timestamps
    end
		add_index :groupings, [:super_group, :group], unique: true
  end
end

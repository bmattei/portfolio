class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :base_type
      t.integer :size
      t.integer :duration
      t.boolean :domestic
      t.boolean :emerging
      t.boolean :reit
      t.integer :quality
      t.boolean :gov
      t.timestamps null: false
    end
  end
end

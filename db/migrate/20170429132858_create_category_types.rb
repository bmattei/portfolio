class CreateCategoryTypes < ActiveRecord::Migration
  def change
    create_table :category_types do |t|
      t.string :name
      t.string :description, limit: 512
      t.timestamps null: false
    end
  end
end

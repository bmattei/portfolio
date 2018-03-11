class CleanupCategories < ActiveRecord::Migration[5.0]
  def change
    drop_table :category_types
    remove_column :categories, :category_type_id
    add_column :categories, :category_type, :integer
  end
end

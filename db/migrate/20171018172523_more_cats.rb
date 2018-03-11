class MoreCats < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :inflation_adjusted, :boolean
  end
end

class CatsAgain < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :growth_value, :integer
  end
end

class CatsEmerging < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :developed_emerging, :integer
  end
end

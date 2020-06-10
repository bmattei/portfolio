class AddPriceToSnapshot < ActiveRecord::Migration[5.0]
  def change
        add_column :snapshots, :price :decimal, precision: 16, scale: 4
  end
end

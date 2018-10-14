class ChangeFactorPrecision < ActiveRecord::Migration[5.2]
  def change
    change_column :ss_factors, :factor, :decimal, precision: 15, scale: 10
  end
end

class AddTaxRates < ActiveRecord::Migration[5.0]
  def change
    add_column :ss_factors, :ss_tax_rate, :decimal, precision: 7, scale: 4
    add_column :ss_factors, :medicare_tax_rate, :decimal, precision: 7, scale: 4
  end
end

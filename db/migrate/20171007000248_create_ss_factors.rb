class CreateSsFactors < ActiveRecord::Migration[5.0]
  def change
    create_table :ss_factors do |t|
      t.integer :year
      t.decimal :max_earnings, precision: 16, scale: 4
      t.decimal :factor, precision: 8, scale: 2
      t.timestamps
    end
    add_index :ss_factors, [:year], unique: true
  end
end

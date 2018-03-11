class CreateSsAdjustments < ActiveRecord::Migration[5.0]
  def change
    create_table :ss_adjustments do |t|
      t.integer :start_year
      t.integer :end_year
      t.integer :full_retirement_months
      t.timestamps
    end

  end
end

class CreateSnapshots < ActiveRecord::Migration[5.0]
  def change
    create_table :snapshots do |t|
      t.integer :capture_id
      t.integer :account_id
      t.integer :ticker_id
      t.decimal :shares, precision: 16, scale: 4
      t.timestamps
    end
  end
end

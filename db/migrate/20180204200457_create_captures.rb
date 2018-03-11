class CreateCaptures < ActiveRecord::Migration[5.0]
  def change
    create_table :captures do |t|
      t.date :capture_date
      t.decimal  "cash",       precision: 16, scale: 2
      t.timestamps
    end
  end
end

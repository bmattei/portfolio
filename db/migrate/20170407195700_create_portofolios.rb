class CreatePortofolios < ActiveRecord::Migration
  def change
    create_table :portofolios do |t|

      t.timestamps null: false
    end
  end
end

class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :city
      t.string :country
      t.integer :user_id
      t.string :address

      t.timestamps
    end
  end
end

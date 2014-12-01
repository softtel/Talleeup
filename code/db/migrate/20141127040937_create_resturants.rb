class CreateResturants < ActiveRecord::Migration
  def change
    create_table :resturants do |t|
      t.string :name
      t.string :address
      t.integer :city_id

      t.timestamps
    end
  end
end

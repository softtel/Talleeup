class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :email
      t.string :phone
      t.string :social
      t.integer :age
      t.string :avatar
      t.integer :user_id
      t.integer :city_id

      t.timestamps
    end
  end
end

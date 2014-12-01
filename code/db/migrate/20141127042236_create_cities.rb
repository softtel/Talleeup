class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name
      t.text :images
      t.integer :country_id
      t.integer :currency_id

      t.timestamps
    end
  end
end

class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.string :images
      t.string :shortname
      t.integer :resturant_id
      t.integer :category_id
      t.float :prices

      t.timestamps
    end
  end
end

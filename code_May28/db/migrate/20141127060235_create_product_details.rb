class CreateProductDetails < ActiveRecord::Migration
  def change
    create_table :product_details do |t|
      t.integer :product_id
      t.integer :ProductComponentValue_id

      t.timestamps
    end
  end
end

class CreateProductComponents < ActiveRecord::Migration
  def change
    create_table :product_components do |t|
      t.integer :product_id
      t.integer :component_value_id

      t.timestamps
    end
  end
end

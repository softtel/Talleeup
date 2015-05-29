class CreateProductComponentValues < ActiveRecord::Migration
  def change
    create_table :product_component_values do |t|
      t.string :name
      t.integer :productcomponent_id

      t.timestamps
    end
  end
end

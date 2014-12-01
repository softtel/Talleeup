class CreateProductComponents < ActiveRecord::Migration
  def change
    create_table :product_components do |t|
      t.string :name

      t.timestamps
    end
  end
end

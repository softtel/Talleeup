class DropTableProductDetails < ActiveRecord::Migration
  def change
    drop_table :product_details
  end
end

class TableProductRenameColumnResturantIdToRestaurantId < ActiveRecord::Migration
  def change
    change_table :products do |t|
      t.rename :resturant_id, :restaurant_id
    end
  end
end

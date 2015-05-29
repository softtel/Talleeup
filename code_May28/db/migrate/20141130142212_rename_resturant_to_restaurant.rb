class RenameResturantToRestaurant < ActiveRecord::Migration
  def change
    rename_table :resturants, :restaurants
  end
end

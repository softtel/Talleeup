class AddColumnFavoriteId < ActiveRecord::Migration
  def change
    add_column :profiles, :favorite_id, :integer
  end
end

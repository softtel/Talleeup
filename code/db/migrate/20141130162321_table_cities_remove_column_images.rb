class TableCitiesRemoveColumnImages < ActiveRecord::Migration
  def change
    remove_column :cities, :images
  end
end

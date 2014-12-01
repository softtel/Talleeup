class TableProductRemoveColumnShortName < ActiveRecord::Migration
  def change
    remove_column :products, :shortname
  end
end

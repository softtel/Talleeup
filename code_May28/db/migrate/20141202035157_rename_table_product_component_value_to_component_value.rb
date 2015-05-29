class RenameTableProductComponentValueToComponentValue < ActiveRecord::Migration
  def change
    rename_table :product_component_values, :component_values
  end
end

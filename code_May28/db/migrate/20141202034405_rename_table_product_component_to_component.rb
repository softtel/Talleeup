class RenameTableProductComponentToComponent < ActiveRecord::Migration
  def change
    rename_table :product_components, :components
  end
end

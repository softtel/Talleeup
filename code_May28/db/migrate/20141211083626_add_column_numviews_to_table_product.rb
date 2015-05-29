class AddColumnNumviewsToTableProduct < ActiveRecord::Migration
  def change
    add_column :products, :numviews, :integer
  end
end

class ChangeDefaultValueNumviewsTableProducts < ActiveRecord::Migration
  def change
    change_column :products, :numviews, :integer, default: 0
  end
end

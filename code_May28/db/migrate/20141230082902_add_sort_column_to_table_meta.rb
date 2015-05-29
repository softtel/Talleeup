class AddSortColumnToTableMeta < ActiveRecord::Migration
  def change
    add_column :meta, :sort, :integer
  end
end

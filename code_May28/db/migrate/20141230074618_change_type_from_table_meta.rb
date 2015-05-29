class ChangeTypeFromTableMeta < ActiveRecord::Migration
  def up
    change_column :meta, :name, :string
    change_column :meta, :datatype, :string
  end

  def down
    change_column :meta, :name, :text
    change_column :meta, :datatype, :text
  end
end

class AddColumnIpToTableLocation < ActiveRecord::Migration
  def change
    add_column :locations, :ip, :string
  end
end

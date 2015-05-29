class ChangeColumnTypeFromTableMeta < ActiveRecord::Migration
  def change
    change_table :meta do |t|
      t.rename :type, :datatype
    end
  end
end

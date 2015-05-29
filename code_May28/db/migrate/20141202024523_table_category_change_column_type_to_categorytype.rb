class TableCategoryChangeColumnTypeToCategorytype < ActiveRecord::Migration
  def change
    change_table :categories do |t|
      t.rename :type, :categorytype
    end
  end
end

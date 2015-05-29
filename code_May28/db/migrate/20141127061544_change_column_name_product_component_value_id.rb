class ChangeColumnNameProductComponentValueId < ActiveRecord::Migration
  def change
    change_table :product_details do |t|
      t.rename :ProductComponentValue_id, :productcomponentvalue_id
    end
  end
end

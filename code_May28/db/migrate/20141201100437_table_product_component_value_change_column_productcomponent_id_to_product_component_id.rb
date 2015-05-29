class TableProductComponentValueChangeColumnProductcomponentIdToProductComponentId < ActiveRecord::Migration
  def change
    change_table :product_component_values do |t|
      t.rename :productcomponent_id, :product_component_id
    end
  end
end

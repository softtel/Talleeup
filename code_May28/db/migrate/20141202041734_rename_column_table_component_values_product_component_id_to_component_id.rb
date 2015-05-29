class RenameColumnTableComponentValuesProductComponentIdToComponentId < ActiveRecord::Migration
  def change
    change_table :component_values do |t|
      t.rename :product_component_id, :component_id
    end
  end
end

ActiveAdmin.register ProductComponent do

  permit_params :product_id, :component_value_id
  index do
    selectable_column
    id_column
    column :product_id do |pc|
      pc.product.name
    end
    column :component_value_id do |pc|
      # pc.component_value_id
      # pc.component_values.component.name
      pc.component_value.name
    end
    # column :created_at
    actions
  end

  filter :product_id
  filter :component_value_id, as: :select, collection: ComponentValue.select(:id, :name).uniq
  filter :created_at
  form do |f|
    f.inputs "Product Components" do
      f.input :product_id
      f.input :component_value_id, as: :select, collection: ComponentValue.select(:id, :name).uniq
    end
    f.actions
  end

end

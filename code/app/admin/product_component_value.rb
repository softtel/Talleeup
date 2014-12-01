ActiveAdmin.register ProductComponentValue do

  permit_params :name, :product_component_id
  index do
    selectable_column
    id_column
    column :name
    column :product_component_id do |pc|
      link_to(pc.product_component.name, admin_product_component_path(pc))
    end
    column :created_at
    actions
  end

  filter :name
  filter :product_component_id, as: :select, collection: ProductComponent.select(:id, :name).uniq
  filter :created_at
  form do |f|
    f.inputs "Component Value Details" do
      f.input :name
      f.input :product_component_id, as: :select, collection: ProductComponent.select(:id, :name).uniq
    end
    f.actions
  end

end

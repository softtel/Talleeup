ActiveAdmin.register ComponentValue do

  permit_params :name, :component_id
  index do
    selectable_column
    id_column
    column :name
    column :component_id do |c|
      link_to(c.component.name, admin_component_path(c))
    end
    column :created_at
    actions
  end

  filter :name
  filter :component_id, as: :select, collection: Component.select(:id, :name).uniq
  filter :created_at
  form do |f|
    f.inputs "Component Value Details" do
      f.input :name
      f.input :component_id, as: :select, collection: Component.select(:id, :name).uniq
    end
    f.actions
  end

end

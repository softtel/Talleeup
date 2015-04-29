ActiveAdmin.register Component do

  permit_params :name,component_values_attributes:[:id,:name,component_id:[:id],:_destroy=>true]

  index do
    selectable_column
    id_column
    column :name
    column :created_at
    actions
  end

  filter :name
  filter :created_at
  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Component Details" do
      f.input :name
    end
    f.inputs "Component Value Details" do
      f.has_many :component_values ,allow_destroy: true do |a|
        a.input :name

      end
    end
    f.actions
  end

end

ActiveAdmin.register Category do

  permit_params :name, :categorytype
  index do
    selectable_column
    id_column
    column :name
    column :categorytype
    column :created_at
    actions
  end

  filter :name
  filter :categorytype
  filter :created_at
  form do |f|
    f.inputs "Category Details" do
      f.input :name
      f.input :categorytype
    end
    f.actions
  end

end

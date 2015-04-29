ActiveAdmin.register Meta do

  permit_params :name, :datatype, :sort
  index do
    selectable_column
    id_column
    column :name
    column :datatype
    column :sort
    column :created_at
    actions
  end

  filter :name
  filter :datatype, as: :select, collection: Meta.get_datatype
  filter :created_at
  form do |f|
    f.inputs "Meta Details" do
      f.input :name
      f.input :datatype, as: :select, collection: Meta.get_datatype
      f.input :sort
    end
    f.actions
  end

end

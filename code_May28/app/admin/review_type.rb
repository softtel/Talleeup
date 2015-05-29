ActiveAdmin.register ReviewType do

  permit_params :name, :sort
  index do
    selectable_column
    id_column
    column :name
    column :sort
    column :created_at
    actions
  end

  filter :name
  filter :sort
  filter :created_at
  form do |f|
    f.inputs "Review type" do
      f.input :name
      f.input :sort
    end
    f.actions
  end

end

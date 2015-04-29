ActiveAdmin.register Currency do

  permit_params :name, :symbol
  index do
    selectable_column
    id_column
    column :name
    column :symbol
    column :created_at
    actions
  end

  filter :name
  filter :symbol
  filter :created_at
  form do |f|
    f.inputs "Currency Details" do
      f.input :name
      f.input :symbol
    end
    f.actions
  end

end

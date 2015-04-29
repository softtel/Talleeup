ActiveAdmin.register User do

  permit_params :email, :encrypted_password


  index do
    selectable_column
    id_column
    column :email
    column :encrypted_password
    column :created_at
    actions
  end

  filter :email
  filter :encrypted_password
  filter :created_at

  form do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :encrypted_password
    end
    f.actions
  end

end

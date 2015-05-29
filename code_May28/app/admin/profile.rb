ActiveAdmin.register Profile do

  permit_params :firstname, :lastname, :address, :email, :age, :user_id, :city_id, :avatar, :cover_image


  index do
    selectable_column
    id_column
    column :firstname
    column :lastname
    column :address
    column :email
    column :age
    column :avatar do |profile|
      profile.avatar_file_name
      image_tag(profile.avatar.url(:thumb))
    end
    column :cover_image do |profile|
      link_to(image_tag(profile.cover_image.url(:thumb)), admin_user_path(profile))
    end
    actions
  end

  filter :firstname
  filter :lastname
  filter :address
  filter :email
  filter :age
  filter :created_at

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs "Profile Details" do
      f.input :firstname
      f.input :lastname
      f.input :address
      f.input :email
      f.input :age
      f.input :avatar, :required => true, :as => :file, :hint => f.image_tag(f.object.avatar.url(:thumb))
      f.input :cover_image, :required => true, :as => :file, :hint => f.image_tag(f.object.cover_image.url(:thumb))
    end
    f.actions
  end

end

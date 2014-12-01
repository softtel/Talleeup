ActiveAdmin.register Product do

  permit_params :name, :prices, :category_id, :restaurant_id, :images


  index do
    selectable_column
    id_column
    column :name
    column :prices
    column :images do |p|
      link_to(image_tag(p.images.url(:thumb)), admin_product_path(p))
    end
    column :category_id
    column :restaurant_id do |p|
      link_to(p.restaurant.name, admin_product_path(p))
    end
    column :created_at
    actions
  end

  filter :name
  filter :price
  filter :category_id
  filter :restaurant_id
  filter :created_at

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs "Product Details" do
      f.input :name
      f.input :prices
      f.input :category_id
      f.input :restaurant_id, as: :select, collection: Restaurant.select(:id, :name).uniq
      f.input :images, :required => true, :as => :file, :hint => f.image_tag(f.object.images.url(:thumb))
    end
    f.actions
  end

end

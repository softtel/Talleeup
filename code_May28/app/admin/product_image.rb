ActiveAdmin.register ProductImage do

  permit_params :product_id, :image

  index do
    selectable_column
    id_column
    column :product_id
    column :image do |c|
      link_to(image_tag(c.image.url(:thumb)), admin_product_image_path(c))
    end
    column :created_at
    actions
  end

  filter :product_id, as: :select, collection: Product.select(:id, :name).uniq
  filter :created_at

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs "Product Images" do
      f.input :product_id
      f.input :image, :required => true, :as => :file, :hint => f.image_tag(f.object.image.url(:thumb))
    end
    f.actions
  end

end
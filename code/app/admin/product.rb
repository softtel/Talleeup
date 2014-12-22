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
    column :restaurant_id do |p|
      link_to(p.restaurant.name, admin_restaurant_path(:id => p.restaurant_id))
    end
    column :category_id do |p|
      unless p.category.nil?
        p.category.name
      end
    end

    column 'Upload' do |p|
      link_to(p.restaurant.name, admin_restaurant_path(:id => p.restaurant_id))
      link_to('images', upload_admin_product_path(p))

    end


    actions

  end

  filter :name
  filter :prices
  filter :category_id, as: :select, collection: Category.select(:id, :name).uniq
  filter :restaurant_id, as: :select, collection: Restaurant.select(:id, :name).uniq
  filter :created_at

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs "Product Details" do
      f.input :name
      f.input :prices
      f.input :category_id, as: :select, collection: Category.select(:id, :name).uniq
      f.input :restaurant_id, as: :select, collection: Restaurant.select(:id, :name).uniq
      f.input :images, :required => true, :as => :file, :hint => f.image_tag(f.object.images.url(:thumb))
    end

    f.actions
  end

  show do |product|
    attributes_table do
      row :name
      row :restaurant_id
      row :prices
      row :images do
        image_tag(product.images.url(:thumb))
      end
      row "Components" do |p|
        p.product_components.each do |pc|
          text_node pc.component_value.name
          text_node ", &nbsp".html_safe
        end
      end
    end
    render "product_components"
  end


  #-------------------------------------------
  member_action :uploadpost, :method=>:post do

  end

  member_action :upload, :method=>:get do

  end


  controller do

    def uploadpost
      @product_image = ProductImage.new(product_id => params[:product_id], image => params[:image])

      if @product_image.save
        render :action => 'admin/products/'+@product_image.product_id+'/upload'
      else

      end
    end

    def upload
      @products = Product.all
      @product_image = ProductImage.new(product_id: 4)
      # renders view 'app/views/admin/products/upload.html.erb'
    end


  end

end

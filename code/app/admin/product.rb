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

    column 'Thumb nails' do |p|
      link_to('images', upload_admin_product_path(:id => p.id))
    end

    column 'Components' do |p|
      link_to('components', components_admin_product_path(:id => p.id))
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
  end


  #--------------------- product image ----------------------
  member_action :uploadpost, :method=>:post do
  end

  member_action :upload, :method=>:get do
  end

  member_action :delete, :method=>:get do
  end

  #--------------------- product component ----------------------
  member_action :add_component, :method=>:post do
  end

  member_action :components, :method=>:get do
  end

  member_action :delete_component, :method=>:get do
  end

  #--------------------- controllers ----------------------
  controller do

    def uploadpost
      @product_image = ProductImage.new(product_id: params[:product_image][:product_id], image: params[:product_image][:image])
      @product_image.save
      redirect_to :action => "upload", :id => @product_image.product_id
    end

    def upload
      @products = Product.all
      @product_image = ProductImage.new(product_id: params[:id])
      @images = Product.find(params[:id]).product_images
    end

    def delete
      @product_image = ProductImage.find(params[:id])
      @product_image.destroy
      redirect_to :action => "upload", :id => @product_image.product_id
    end

    def productimage_params
      params.require(:productimage).permit(:product_id, :image)
    end

#--------------------- components ----------------------
    def add_component
      @product_component = ProductComponent.create(product_id: params[:product_component][:product_id], component_value_id: params[:product_component][:component_value_id])
      redirect_to :action => "components", :id => @product_component.product_id
    end

    def components
      @components = ProductComponent.where(product_id: params[:id])
      @component_values = ComponentValue.all
      @product_component = ProductComponent.new(product_id: params[:id])
    end

    def delete_component
      @product_component = ProductComponent.find(params[:id])
      @product_component.destroy
      redirect_to :action => "components", :id => @product_component.product_id
    end
  end

end

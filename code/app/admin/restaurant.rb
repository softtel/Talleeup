ActiveAdmin.register Restaurant do

  permit_params :name, :address, :city_id,:country_id


  index do
    selectable_column
    id_column
    column :name
    column :address

    column :city_id do |r|
      link_to(r.city.name, admin_city_path(r))
    end
    column :created_at
    actions
  end

  filter :name
  filter :address
  filter :country_id, as: :select, collection: Country.select(:id, :name).uniq
  filter :city_id, as: :select, collection: City.select(:id, :name).uniq
  filter :created_at

  form do |f|
    f.inputs "Restaurant Details" do
      f.input :name
      f.input :address
      f.input :country_id, as: :select, collection: Country.select(:id, :name).order(name: :asc).uniq, :input_html => {
          :onchange => remote_request(:post, :change_country, {:country_id=>"$('#restaurant_country_id').val()"}, "restaurant_city_id")
      }
      if params[:id].present?
        f.input :city_id,as: :select,collection: City.where(country_id: City.where(id: Restaurant.where(id: params[:id]).first().city_id).first().country_id).select(:id, :name).uniq
      else
        f.input :city_id,as: :select,collection: City.where(country_id: Country.order(name: :asc).first().id).select(:id, :name).uniq
      end
      #f.input :country_id,as: :select, collection: Country.select(:id, :name).uniq, :input_html => {
          #:onchange => "
   # var user = $(this).val();

  #  $('#restaurant_city_id').val(0).find('option').each(function(){
   #   var $option = $(this),
   #     isCorrectUser = ($option.attr('data-user') === user);

    #    $option.prop('visible',!isCorrectUser);
    #});
  #"
    #  }
    #  f.input :city_id,as: :select, collection: City.all.map{ |loc|
    #    [loc.name,loc.id, {"data-user" => loc.country_id}]
     # }
    end
    f.actions
  end

  show do |restaurant|
    attributes_table do
      row :name
      row :address
      row :city_id
      row "create new product" do
        link_to('create', new_admin_product_path(:restaurant_id => restaurant.id))
      end
    end
      restaurant = Restaurant.find(params[:id])

        table_for(restaurant.products, :sortable => true, :class => 'index_table') do
          column :name
          column :prices
          column :images do |p|
            link_to(image_tag(p.images.url(:thumb)), admin_product_path(p))
          end
          column :category_id do |p|
            unless p.category.nil?
              p.category.name
            end
          end
          column "Components" do |p|
            p.product_components.each do |pc|
              text_node pc.component_value.name
              text_node ", &nbsp".html_safe
            end
          end
          column "Actions" do |product|
            text_node link_to('view', admin_product_path(product))
            text_node "&nbsp".html_safe
            text_node link_to('edit', edit_admin_product_path(product))
            text_node "&nbsp".html_safe
            text_node link_to 'delete', admin_product_path(product), :data => { :'confirm' => 'Are you sure you want to delete this?' }, :method => :delete, :class=>"delete_link member_link"
          end
        end

      # render partial: "product", locals: restaurant
  end

  # /admin/posts/:id/comments
  member_action :products do
    @restaurant = Restaurant.find(params[:id])

    filter :name
    panel "P&L" do

      table_for(@restaurant.products, :sortable => true, :class => 'index_table') do
        column :name
        column :price
        column "action" do |product|
          text_node edit_admin_product_path(product)
          text_node "&nbsp".html_safe
          text_node destroy_admin_product_path(product)
        end
      end

    end

    # This will render app/views/admin/posts/comments.html.erb
  end
  member_action :change_country, :method=>:post do
  end
  controller do
    def change_country
      @flats = City.where(country_id: params[:country_id])
      render :text=>view_context.options_from_collection_for_select(@flats, :id, :name)
    end

  end
end

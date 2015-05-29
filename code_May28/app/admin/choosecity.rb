ActiveAdmin.register SelectCity do

  permit_params :country_id, :city_id
  collection_action :autocomplete_choosecity_country_id, :method => :get
  controller do
    autocomplete :choosecity, :country_id
  end
  index do
    selectable_column
    id_column
    column :country_id do |c|
      c.country.name
    end

    column :city_id do |c|
      c.city.name
    end

    column :created_at
    actions
  end


  filter :country_id, as: :select, collection: Country.select(:id, :name)
  filter :city_id, as: :select, collection: City.select(:id, :name)
  filter :created_at

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Choose City Details" do

      f.input :country_id, :as => :autocomplete, :url => "/home/getAutocomplete"
      f.input :city_id, as: :select, collection: City.select(:id, :name).uniq,:required => true,:hint => "This field should be filled in"
      # f.input :image, :required => false, :as => :file
      #f.input :image, :required => true, :as => :file, :hint => f.image_tag(f.object.image.url(:thumb))
    end
    f.actions
  end

end


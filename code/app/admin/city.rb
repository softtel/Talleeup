ActiveAdmin.register City do

  permit_params :name, :image, :country_id, :currency_id
  index do
    selectable_column
    id_column
    column :name
    column :image do |c|
      link_to(image_tag(c.image.url(:thumb)), admin_city_path(c))
    end
    column :country_id do |c|
      c.country.name
    end
    column :currency_id do |c|
      c.currency.name
    end
    column :created_at
    actions
  end

  filter :name
  filter :country_id, as: :select, collection: Country.select(:id, :name)
  filter :currency_id, as: :select, collection: Currency.select(:id, :name)
  filter :created_at

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "City Details" do
      f.input :name,:required => true,:hint => "This field should be filled in"
      f.input :country_id, as: :select, collection: Country.select(:id, :name).uniq,:required => true,:hint => "This field should be filled in"
      f.input :currency_id, as: :select, collection: Currency.select(:id, :name).uniq,:required => true,:hint => "This field should be filled in"
      # f.input :image, :required => false, :as => :file
      f.input :image, :required => true, :as => :file, :hint => f.image_tag(f.object.image.url(:thumb))
    end
    f.actions
  end

end


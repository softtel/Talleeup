ActiveAdmin.register Restaurant do

  permit_params :name, :address, :city_id


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
  # filter :country, as: :select, collection: Country.select(:id, :name).uniq
  filter :city_id, as: :select, collection: City.select(:id, :name).uniq
  filter :created_at

  form do |f|
    f.inputs "Restaurant Details" do
      f.input :name
      f.input :address
      f.input :city_id, as: :select, collection: City.select(:id, :name).uniq
    end
    f.actions
  end

end

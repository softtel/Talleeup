ActiveAdmin.register FilterCity do

  permit_params  :city_id ,:country_id
  index do
    selectable_column
    id_column


    column :city_id do |c|
      c.city.name
    end

    column :created_at
    actions
  end

  filter :country_id, as: :select, collection: Country.select(:id, :name).order(name: :asc).uniq
  filter :city_id, as: :select, collection: City.select(:id, :name).order(name: :asc).uniq

  filter :created_at

  form :html => { :enctype => "multipart/form-data" } do |f|
    #f.semantic_errors *f.object.errors.keys
    f.inputs "Filter City Details" do
      #f.input :name,:required => true,:hint => "This field should be filled in"
      f.input :country_id, as: :select, collection: Country.select(:id, :name).order(name: :asc).uniq, :input_html => {
          :onchange => remote_request(:post, :change_country, {:country_id=>"$('#filter_city_country_id').val()"}, "filter_city_city_id")
      }
      #f.input :city_id, as: :select, collection: City.where(country_id: Country.order(name: :asc).first().id).select(:id, :name).uniq,:required => true,:hint => "This field should be filled in"

      if params[:id].present?
        f.input :city_id,as: :select,collection: City.where(country_id: City.where(id: FilterCity.where(id: params[:id]).first().country_id)).select(:id, :name).uniq,:required => true,:hint => "This field should be filled in"
      else
        f.input :city_id,as: :select,collection: City.where(country_id: Country.order(name: :asc).first().id).select(:id, :name).uniq,:required => true,:hint => "This field should be filled in"
      end
      #f.input :currency_id, as: :select, collection: Currency.select(:id, :name).uniq,:required => true,:hint => "This field should be filled in"
      # f.input :image, :required => false, :as => :file
      #f.input :image, :required => true, :as => :file, :hint => f.image_tag(f.object.image.url(:thumb))
    end
    f.actions
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


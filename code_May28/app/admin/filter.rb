ActiveAdmin.register Filter do

  permit_params :component_id, :type
  index do
    selectable_column
    id_column
    column :component_id do |c|
      c.component.name
    end

    column :created_at
    actions
  end

  filter :type
  filter :component_id, as: :select, collection: Component.select(:id, :name).uniq
  filter :created_at

  form :html => { :enctype => "multipart/form-data" } do |f|

    f.inputs "Filter Details" do
      f.input :component_id,:required => true,:hint => "This field should be filled in",as: :select, collection: Component.select(:id, :name).uniq
      #f.input :type, as: :select #, collection: Country.select(:id, :name).uniq,:required => true,:hint => "This field should be filled in"
      #f.input :currency_id, as: :select, collection: Currency.select(:id, :name).uniq,:required => true,:hint => "This field should be filled in"
      # f.input :image, :required => false, :as => :file
      #f.input :image, :required => true, :as => :file, :hint => f.image_tag(f.object.image.url(:thumb))
    end
    f.actions
  end

end


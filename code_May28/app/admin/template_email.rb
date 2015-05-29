ActiveAdmin.register TemplateEmail do

  permit_params :header, :footer
  index do
    selectable_column
    id_column
    column :header, :as => :ckeditor
    column :footer, :as => :ckeditor
    actions
  end

  filter :created_at
  form do |f|
    f.inputs "Template email" do
      f.input :header, :as => :ckeditor
      f.input :footer, :as => :ckeditor
    end
    f.actions
  end

end

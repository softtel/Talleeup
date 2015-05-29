class CreateTemplateEmails < ActiveRecord::Migration
  def change
    create_table :template_emails do |t|
      t.text :title
      t.text :header
      t.text :content
      t.text :footer

      t.timestamps
    end
  end
end

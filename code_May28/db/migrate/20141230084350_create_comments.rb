class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.text :images
      t.integer :product_id
      t.integer :user_id

      t.timestamps
    end
  end
end

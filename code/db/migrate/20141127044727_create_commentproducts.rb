class CreateCommentproducts < ActiveRecord::Migration
  def change
    create_table :commentproducts do |t|
      t.text :content
      t.integer :reviewsproductuser_id
      t.string :images

      t.timestamps
    end
  end
end

class CreateReviewsproducts < ActiveRecord::Migration
  def change
    create_table :reviewsproducts do |t|
      t.integer :user_id
      t.integer :product_id
      t.integer :status
      t.float :totalpoint

      t.timestamps
    end
  end
end

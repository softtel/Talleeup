class CreateReviewsproductusers < ActiveRecord::Migration
  def change
    create_table :reviewsproductusers do |t|
      t.integer :user_id
      t.integer :point
      t.integer :typereviews_id
      t.integer :product_id

      t.timestamps
    end
  end
end

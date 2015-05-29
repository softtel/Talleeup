class DeleteTableReviewProductUserReviewsProductTypeReviews < ActiveRecord::Migration
  def change
    drop_table :reviewsproducts
    drop_table :reviewsproductusers
    drop_table :typereviews
  end
end

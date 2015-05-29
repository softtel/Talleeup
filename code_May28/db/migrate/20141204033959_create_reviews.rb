class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :totalpoint
      t.integer :user_id
      t.integer :product_id

      t.timestamps
    end
  end
end

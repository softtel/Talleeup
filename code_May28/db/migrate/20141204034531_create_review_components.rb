class CreateReviewComponents < ActiveRecord::Migration
  def change
    create_table :review_components do |t|
      t.integer :point
      t.integer :review_type_id
      t.integer :review_id

      t.timestamps
    end
  end
end

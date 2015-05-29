class CreateReviewTypes < ActiveRecord::Migration
  def change
    create_table :review_types do |t|
      t.string :name
      t.integer :sort

      t.timestamps
    end
  end
end

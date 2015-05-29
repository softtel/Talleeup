class CreateExperiences < ActiveRecord::Migration
  def change
    create_table :experiences do |t|
      t.integer :product_id
      t.integer :user_id
      t.string :type

      t.timestamps
    end
  end
end

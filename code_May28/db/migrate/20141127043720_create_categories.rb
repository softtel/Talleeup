class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.string :type , :limit =>50
      t.timestamps
    end
  end
end

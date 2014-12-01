class CreateTypereviews < ActiveRecord::Migration
  def change
    create_table :typereviews do |t|
      t.string :name
      t.integer :sort

      t.timestamps
    end
  end
end

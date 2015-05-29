class DeleteColumnImagesFromTableComment < ActiveRecord::Migration
  def change
    remove_column :comments, :images
  end
end

class AddAttachmentImagesToProducts < ActiveRecord::Migration
  def self.up
    change_table :products do |t|
      t.attachment :images
    end
  end

  def self.down
    remove_attachment :products, :images
  end
end

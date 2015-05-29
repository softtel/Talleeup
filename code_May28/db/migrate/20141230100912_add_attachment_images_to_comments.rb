class AddAttachmentImagesToComments < ActiveRecord::Migration
  def self.up
    change_table :comments do |t|
      t.attachment :images
    end
  end

  def self.down
    remove_attachment :comments, :images
  end
end

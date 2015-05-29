class RemoveAvatarAndCoverImageFromTableProfile < ActiveRecord::Migration
  def change
    remove_column :profiles, :avatar
    remove_column :profiles, :coverImage
  end
end

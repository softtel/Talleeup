class AddColumnCoverImageToTableProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :coverImage, :string
  end
end

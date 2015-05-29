class AddColumnNumLikeToTableComments < ActiveRecord::Migration
  def change
    add_column :commentproducts, :numlikes, :integer
  end
end

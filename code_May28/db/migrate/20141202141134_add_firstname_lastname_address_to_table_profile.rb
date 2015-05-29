class AddFirstnameLastnameAddressToTableProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :firstname, :string
    add_column :profiles, :lastname, :string
    add_column :profiles, :address, :string
  end
end

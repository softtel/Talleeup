class CreateMetaUsers < ActiveRecord::Migration
  def change
    create_table :meta_users do |t|
      t.text :value
      t.integer :user_id
      t.integer :meta_id

      t.timestamps
    end
  end
end

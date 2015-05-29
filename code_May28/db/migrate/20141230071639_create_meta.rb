class CreateMeta < ActiveRecord::Migration
  def change
    create_table :meta do |t|
      t.text :name
      t.text :type

      t.timestamps
    end
  end
end

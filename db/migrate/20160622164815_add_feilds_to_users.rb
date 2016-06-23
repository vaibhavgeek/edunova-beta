class AddFeildsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :image_id, :string
    add_column :users, :name, :string
    add_column :users, :gender, :string
    add_column :users, :intrested_in, :string
    add_column :users, :description, :string
 	add_column :users, :username, :string , null: false , default: ""
 	add_index :users, :username, unique: true 
 	add_index :users, :name
  end
end

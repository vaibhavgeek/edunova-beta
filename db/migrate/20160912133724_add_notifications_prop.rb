class AddNotificationsProp < ActiveRecord::Migration
  def change
  	add_column :notifications ,  :category , :string 
  end
end

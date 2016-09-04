class TypeIsKeyword < ActiveRecord::Migration
  def change
  	rename_column :notewidgets , :type , :set_type
  end
end

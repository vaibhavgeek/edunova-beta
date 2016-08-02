class CreateLabels < ActiveRecord::Migration
  def change
    create_table :labels do |t|
      t.string :name
      t.integer :user_id
      t.boolean :edunova_cert
      t.string :media

      t.timestamps null: false
    end
  end
end

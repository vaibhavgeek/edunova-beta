class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :name
      t.string :description
      t.string :note_from_author
      t.integer :comments_id
      t.boolean :spam
      t.string :labels
      t.integer :user_id

      t.timestamps null: false
    end
  end
end

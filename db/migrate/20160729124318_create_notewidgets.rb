class CreateNotewidgets < ActiveRecord::Migration
  def change
    create_table :notewidgets do |t|
      t.integer :note_id
      t.string :tag_one
      t.string :tag_two
      t.string :tag_three
      t.string :tag_four
      t.string :tag_five
      t.string :tag_six
      t.string :tag_seven
      t.string :tag_eight
      t.string :tag_nine
      t.string :tag_ten
      t.string :type
      t.boolean :certified

      t.timestamps null: false
    end
  end
end

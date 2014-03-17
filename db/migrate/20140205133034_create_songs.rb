class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.belongs_to :category
      t.belongs_to :artist

      t.string   :title
      t.string   :cover

      t.integer  :arranger_id
      t.string   :length
      t.integer  :difficulty
      t.string   :comment
      t.string   :status
      t.boolean  :onclient

      t.timestamps
    end
  end
end

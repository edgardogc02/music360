class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :title
      t.string :cover
      t.belongs_to :category
      t.belongs_to :artist
      t.timestamps
    end
  end
end

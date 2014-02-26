class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :title
      t.belongs_to :challenge
      t.belongs_to :category
      t.belongs_to :artist
      t.timestamps
    end
  end
end

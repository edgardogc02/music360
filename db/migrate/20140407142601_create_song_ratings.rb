class CreateSongRatings < ActiveRecord::Migration
  def change
    create_table :songratings do |t|
      t.integer :song_id, null: false
      t.integer :user_id, null: false
      t.integer :rating, null: false

      t.timestamps
    end
    add_index :songratings, :song_id
    add_index :songratings, :user_id
  end
end

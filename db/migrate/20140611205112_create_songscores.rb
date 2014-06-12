class CreateSongscores < ActiveRecord::Migration
  def change
    create_table :songscore do |t|
      t.string :song
      t.integer :song_id
      t.string :user
      t.integer :user_id
      t.integer :score
      t.integer :instrument
      t.string :filename
      t.date :date
      t.datetime :datetime

      t.timestamps
    end
  end
end

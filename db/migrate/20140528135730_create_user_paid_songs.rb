class CreateUserPaidSongs < ActiveRecord::Migration
  def change
    create_table :user_paid_songs do |t|
      t.integer :user_id
      t.integer :song_id

      t.timestamps
    end
  end
end

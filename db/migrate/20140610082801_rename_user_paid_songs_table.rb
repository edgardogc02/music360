class RenameUserPaidSongsTable < ActiveRecord::Migration
  def self.up
    rename_table :user_paid_songs, :user_purchased_songs
  end

 def self.down
    rename_table :user_purchased_songs, :user_paid_songs
 end
end

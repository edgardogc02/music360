class AddTokenToUserPaidSongs < ActiveRecord::Migration
  def change
    add_column :user_paid_songs, :token, :string
  end
end

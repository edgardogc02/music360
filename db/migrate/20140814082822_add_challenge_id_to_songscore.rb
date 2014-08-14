class AddChallengeIdToSongscore < ActiveRecord::Migration
  def change
    add_column :songscore, :challenge_id, :integer
  end
end

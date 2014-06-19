class AddFirstChallengeIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_challenge_id, :integer
  end
end

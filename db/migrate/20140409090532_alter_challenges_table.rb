class AlterChallengesTable < ActiveRecord::Migration

  def change
    rename_column :challenges, :user1, :challenger_id
    rename_column :challenges, :user2, :challenged_id
  end

end

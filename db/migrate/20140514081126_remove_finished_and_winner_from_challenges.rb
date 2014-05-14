class RemoveFinishedAndWinnerFromChallenges < ActiveRecord::Migration
  def change
    remove_column :challenges, :winner
    remove_column :challenges, :finished
  end
end

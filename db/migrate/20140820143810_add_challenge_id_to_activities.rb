class AddChallengeIdToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :challenge_id, :integer
  end
end

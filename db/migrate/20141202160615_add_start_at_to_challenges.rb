class AddStartAtToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :start_at, :datetime
  end
end

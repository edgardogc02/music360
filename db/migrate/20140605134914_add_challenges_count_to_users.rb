class AddChallengesCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :challenges_count, :integer
  end
end

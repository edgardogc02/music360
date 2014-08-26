class AddEndAtToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :end_at, :datetime
  end
end

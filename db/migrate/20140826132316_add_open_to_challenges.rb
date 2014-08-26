class AddOpenToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :open, :boolean
  end
end

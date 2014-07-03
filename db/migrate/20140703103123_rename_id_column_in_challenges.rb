class RenameIdColumnInChallenges < ActiveRecord::Migration
  def change
    rename_column :challenges, :challenge_id, :id
  end
end

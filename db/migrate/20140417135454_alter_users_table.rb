class AlterUsersTable < ActiveRecord::Migration
  def change
    remove_column :users, :level
    add_column :users, :careerpoints, :integer
  end
end

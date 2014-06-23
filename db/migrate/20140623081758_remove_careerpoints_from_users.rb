class RemoveCareerpointsFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :careerpoints
  end
end

class AddXpToUsers < ActiveRecord::Migration
  def change
    add_column :users, :xp, :integer
  end
end

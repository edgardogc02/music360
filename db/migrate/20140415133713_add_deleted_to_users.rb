class AddDeletedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :deleted, :boolean
    add_column :users, :deleted_at, :datetime
  end
end

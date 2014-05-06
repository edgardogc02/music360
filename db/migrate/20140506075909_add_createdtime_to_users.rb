class AddCreatedtimeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :createdtime, :datetime
  end
end

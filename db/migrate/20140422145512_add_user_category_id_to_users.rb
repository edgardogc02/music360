class AddUserCategoryIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :user_category_id, :int
  end
end

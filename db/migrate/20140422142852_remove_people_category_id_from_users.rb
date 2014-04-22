class RemovePeopleCategoryIdFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :people_category_id, :string
  end
end

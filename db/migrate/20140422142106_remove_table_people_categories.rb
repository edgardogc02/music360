class RemoveTablePeopleCategories < ActiveRecord::Migration
  def change
    drop_table :people_categories
  end
end

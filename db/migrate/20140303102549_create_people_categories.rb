class CreatePeopleCategories < ActiveRecord::Migration
  def change
    create_table :people_categories do |t|
      t.string :title

      t.timestamps
    end
  end
end
